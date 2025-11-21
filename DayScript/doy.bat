@echo off
REM User-friendly wrapper for doy_calculator.ps1
REM Handles common help arguments and provides better error messages

setlocal enabledelayedexpansion

REM Check for help arguments
if "%~1"=="" goto :runit
if /i "%~1"=="-h" goto :showhelp
if /i "%~1"=="--h" goto :showhelp
if /i "%~1"=="-help" goto :showhelp
if /i "%~1"=="--help" goto :showhelp
if /i "%~1"=="/h" goto :showhelp
if /i "%~1"=="/help" goto :showhelp
if /i "%~1"=="/?" goto :showhelp
if /i "%~1"=="-?" goto :showhelp
if /i "%~1"=="?" goto :showhelp
if /i "%~1"=="help" goto :showhelp

:runit
REM Run the PowerShell script
powershell.exe -ExecutionPolicy Bypass -File "%~dp0doy_calculator.ps1" %*
goto :eof

:showhelp
powershell.exe -ExecutionPolicy Bypass -Command "Get-Help '%~dp0doy_calculator.ps1' -Detailed"
goto :eof
