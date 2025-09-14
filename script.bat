:: Made by deadcode

@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Set console dimensions
mode con: cols=70 lines=30

:: Check Admin Perms
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    call :CenterText "ERROR: This script requires Administrator privileges!"
    echo.
    call :CenterText "Please right-click and select 'Run as administrator'"
    echo.
    pause
    exit /b 1
)

:: Art
color 40
cls
echo.
call :CenterText "============================================="
call :CenterText "        WELCOME TO HIDE HELPER PANEL"
call :CenterText "============================================="
echo.
timeout /t 2 /nobreak >nul

:: Main Menu
:MainMenu
color 4
cls
echo.
call :CenterText "============================================="
call :CenterText "           HIDE PANEL - MAIN MENU"
call :CenterText "============================================="
echo.
call :CenterText "1. Disable User Data"
call :CenterText "2. Disable SysMain (Prefetch)"
call :CenterText "3. Disable LastActivity (RunMRU)"
call :CenterText "4. Disable Nvidia History"
call :CenterText "5. Exit"
echo.
call :CenterText "============================================="
echo.
set /p "choice=       Select an option (1-5): "

if "%choice%"=="1" goto DisableUserData
if "%choice%"=="2" goto DisableSysMain
if "%choice%"=="3" goto DisableLastActivity
if "%choice%"=="4" goto DisableNvidiaHistory
if "%choice%"=="5" goto Exit

echo.
call :CenterText "Invalid selection. Please try again."
timeout /t 2 /nobreak >nul
goto MainMenu

:: Functions
:DisableUserData
cls
echo.
call :CenterText "============================================="
call :CenterText "         DISABLING USER DATA SERVICE"
call :CenterText "============================================="
echo.

:: Stop Data Usage
sc stop "DusmSvc" >nul 2>&1
if !errorlevel! equ 0 (
    call :CenterText "[+] Service DusmSvc stopped successfully"
) else (
    call :CenterText "[-] Could not stop DusmSvc (may already be stopped)"
)

:: Off autorun
sc config "DusmSvc" start= disabled >nul 2>&1
if !errorlevel! equ 0 (
    call :CenterText "[+] Service DusmSvc startup set to disabled"
) else (
    call :CenterText "[-] Could not disable DusmSvc startup"
)

echo.
call :CenterText "Data Usage service (DusmSvc) has been disabled!"
echo.
call :CenterText "Note: Run as Administrator if commands failed."
echo.
pause
goto MainMenu

:DisableSysMain
cls
echo.
call :CenterText "============================================="
call :CenterText "         DISABLING SYSMAIN SERVICE"
call :CenterText "============================================="
echo.

:: Stop SysMain
sc stop "SysMain" >nul 2>&1
if !errorlevel! equ 0 (
    call :CenterText "[+] Service SysMain stopped successfully"
) else (
    call :CenterText "[-] Could not stop SysMain (may already be stopped)"
)

:: Off autorun
sc config "SysMain" start= disabled >nul 2>&1
if !errorlevel! equ 0 (
    call :CenterText "[+] Service SysMain startup set to disabled"
) else (
    call :CenterText "[-] Could not disable SysMain startup"
)

echo.
call :CenterText "SysMain service (Prefetch) has been disabled!"
echo.
call :CenterText "Note: Run as Administrator if commands failed."
echo.
pause
goto MainMenu

:DisableLastActivity
cls
echo.
call :CenterText "============================================="
call :CenterText "         DISABLING RUNMRU HISTORY"
call :CenterText "============================================="
echo.

:: Create reg file for import perms
echo Windows Registry Editor Version 5.00 > temp_permissions.reg
echo. >> temp_permissions.reg
echo [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU] >> temp_permissions.reg
echo "MRUList"="" >> temp_permissions.reg

:: Import REG file
reg import temp_permissions.reg >nul 2>&1

if !errorlevel! equ 0 (
    call :CenterText "[+] RunMRU history has been cleared"
) else (
    call :CenterText "[-] Could not clear RunMRU history"
)

:: Delete temp file
del temp_permissions.reg >nul 2>&1

:: Alt method
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StartMenuRun" /t REG_DWORD /d 0 /f >nul 2>&1

call :CenterText "[+] Run command history tracking disabled"
echo.
call :CenterText "LastActivity (RunMRU) has been disabled!"
echo.
pause
goto MainMenu

:DisableNvidiaHistory
cls
echo.
call :CenterText "============================================="
call :CenterText "         DISABLING NVIDIA HISTORY"
call :CenterText "============================================="
echo.
call :CenterText "Deleting Drs folder..."
echo.

:: Check folder
if exist "C:\ProgramData\NVIDIA Corporation\Drs" (
    rd /s /q "C:\ProgramData\NVIDIA Corporation\Drs" >nul 2>&1
    if !errorlevel! equ 0 (
        call :CenterText "[+] NVIDIA Drs folder deleted successfully"
    ) else (
        call :CenterText "[-] Could not delete Drs folder (access denied)"
        call :CenterText "Run as Administrator to delete protected files"
    )
) else (
    call :CenterText "[-] Drs folder not found or already deleted"
)
echo.
pause
goto MainMenu

:Exit
cls
echo.
call :CenterText "============================================="
call :CenterText "      THANK YOU FOR USING HIDE PANEL!"
call :CenterText "============================================="
echo.
timeout /t 2 /nobreak >nul
exit

:CenterText
setlocal
set "text=%~1"
set "spaces="
set /a width=70
set /a len=0

:: Calculate text length
for /f "delims=" %%i in ('cmd /u /c echo.!text!^|find /v /c ""') do set /a len=%%i
set /a indent=(width - len) / 2

:: Create indentation
for /l %%i in (1,1,%indent%) do set "spaces=!spaces! "

:: Display centered text
echo.!spaces!!text!
endlocal
goto :eof
