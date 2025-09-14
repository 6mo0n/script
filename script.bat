:: Made by deadcode

@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title HIDE Panel

:: Check Admin Perms
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo    [ERROR] This script requires Administrator privileges!
    echo    Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

:: Art
color 40
cls
echo.    ========\ Welcome to HIDE HELPER PANEL :0 /========
echo.
timeout /t 2 /nobreak >nul

:: Main Menu
:MainMenu
color 4
cls
echo.
echo    ========================================
echo         HIDE Panel - Main Menu
echo    ========================================
echo.
echo    [1] Disable User Data
echo    [2] Disable SysMain (Prefetch)
echo    [3] Disable LastActivity (RunMRU)
echo    [4] Disable Nvidia History
echo    [5] Exit
echo.
echo    ========================================
echo.

choice /c 123456 /n /m "Select an option (1-5): "

if %errorlevel% equ 1 goto DisableUserData
if %errorlevel% equ 2 goto DisableSysMain
if %errorlevel% equ 3 goto DisableLastActivity
if %errorlevel% equ 4 goto DisableNvidiaHistory
if %errorlevel% equ 5 goto Exit

:: Funct
:DisableUserData
cls
echo.
echo    Disabling Data Usage Service (DusmSvc)...
echo.

:: Stop Data Usage
sc stop "DusmSvc" >nul 2>&1
if !errorlevel! equ 0 (
    echo    [+] Service DusmSvc stopped successfully
) else (
    echo    [-] Could not stop DusmSvc (may already be stopped)
)

:: Off autorun
sc config "DusmSvc" start= disabled >nul 2>&1
if !errorlevel! equ 0 (
    echo    [+] Service DusmSvc startup set to disabled
) else (
    echo    [-] Could not disable DusmSvc startup
)

echo.
echo    Data Usage service (DusmSvc) has been disabled!
echo.
echo    Note: Run as Administrator if commands failed.
echo.
pause
goto MainMenu

:DisableSysMain
cls
echo.
echo    Disabling SysMain Service...
echo.

:: Stop SysMain
sc stop "SysMain" >nul 2>&1
if !errorlevel! equ 0 (
    echo    [+] Service SysMain stopped successfully
) else (
    echo    [-] Could not stop SysMain (may already be stopped)
)

:: Off autorun
sc config "SysMain" start= disabled >nul 2>&1
if !errorlevel! equ 0 (
    echo    [+] Service SysMain startup set to disabled
) else (
    echo    [-] Could not disable SysMain startup
)

echo.
echo    SysMain service (Prefetch) has been disabled!
echo.
echo    Note: Run as Administrator if commands failed.
echo.
pause
goto MainMenu

:DisableLastActivity
cls
echo.
echo    Disabling RunMRU History...
echo.

:: Create reg file for import perms
echo Windows Registry Editor Version 5.00 > temp_permissions.reg
echo. >> temp_permissions.reg
echo [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU] >> temp_permissions.reg
echo "MRUList"="" >> temp_permissions.reg

:: Import REG file
reg import temp_permissions.reg >nul 2>&1

if !errorlevel! equ 0 (
    echo    [+] RunMRU history has been cleared
) else (
    echo    [-] Could not clear RunMRU history
)

:: Delete temp file
del temp_permissions.reg >nul 2>&1

:: Alt method
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StartMenuRun" /t REG_DWORD /d 0 /f >nul 2>&1

echo    [+] Run command history tracking disabled
echo.
echo    LastActivity (RunMRU) has been disabled!
echo.
pause
goto MainMenu

:DisableNvidiaHistory
cls
echo.
echo    Disabling NVIDIA History...
echo    Deleting Drs folder...
echo.

:: Check folder
if exist "C:\ProgramData\NVIDIA Corporation\Drs" (
    rd /s /q "C:\ProgramData\NVIDIA Corporation\Drs" >nul 2>&1
    if !errorlevel! equ 0 (
        echo    [+] NVIDIA Drs folder deleted successfully
    ) else (
        echo    [-] Could not delete Drs folder (access denied)
        echo    Run as Administrator to delete protected files
    )
) else (
    echo    [-] Drs folder not found or already deleted
)
echo.
pause
goto MainMenu

:Exit
cls
echo.
echo    Thank you for using HIDE Panel!
echo.
timeout /t 2 /nobreak >nul
exit
