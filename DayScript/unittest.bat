@echo off
REM Unit Test Runner for doy_calculator.ps1
REM Outputs results to both console and unittest.log

setlocal enabledelayedexpansion

set "LOGFILE=%~dp0unittest.log"
set "SCRIPT=%~dp0doy_calculator.ps1"
set "PASSED=0"
set "FAILED=0"
set "TOTAL=0"

REM Clear the log file
type nul > "%LOGFILE%"

REM Skip to main execution
goto :main

REM ========================================
REM Function Definitions
REM ========================================

REM Function to run a test
:RunTest
set /a TOTAL+=1
set "TEST_DATE=%~1"
set "EXPECTED=%~2"

REM Run doy_calculator.ps1 and capture output
for /f "tokens=*" %%a in ('powershell.exe -ExecutionPolicy Bypass -Command "$result = & '%SCRIPT%' -inputDate ([datetime]'%TEST_DATE%'); Write-Output $result"') do set "OUTPUT=%%a"

REM Extract the day number from output (e.g., "Day of Year: 1" -> "1")
for /f "tokens=4" %%b in ("%OUTPUT%") do set "ACTUAL=%%b"

REM Compare expected vs actual
if "%ACTUAL%"=="%EXPECTED%" (
    call :LogEcho "  [PASS] Expected: %EXPECTED%, Got: %ACTUAL%"
    set /a PASSED+=1
) else (
    call :LogEcho "  [FAIL] Expected: %EXPECTED%, Got: %ACTUAL%"
    set /a FAILED+=1
)
goto :eof

REM Function to test without parameters (should use current date)
:RunTestNoParam
set /a TOTAL+=1

REM Run doy_calculator.ps1 without parameters and capture output
for /f "tokens=*" %%a in ('powershell.exe -ExecutionPolicy Bypass -Command "$result = & '%SCRIPT%'; Write-Output $result"') do set "OUTPUT=%%a"

REM Extract the day number from output
for /f "tokens=4" %%b in ("%OUTPUT%") do set "ACTUAL=%%b"

REM Get today's expected day of year
for /f %%c in ('powershell.exe -Command "(Get-Date).DayOfYear"') do set "EXPECTED=%%c"

REM Compare expected vs actual
if "%ACTUAL%"=="%EXPECTED%" (
    call :LogEcho "  [PASS] No parameter defaults to today (day %EXPECTED%)"
    set /a PASSED+=1
) else (
    call :LogEcho "  [FAIL] No parameter: Expected today=%EXPECTED%, Got: %ACTUAL%"
    set /a FAILED+=1
)
goto :eof

REM Function to test different date string formats
:RunTestFormat
set /a TOTAL+=1
set "TEST_DATE=%~1"
set "EXPECTED=%~2"
set "FORMAT_DESC=%~3"

REM Run doy_calculator.ps1 with string format and capture output
for /f "tokens=*" %%a in ('powershell.exe -ExecutionPolicy Bypass -Command "$result = & '%SCRIPT%' -inputDate '%TEST_DATE%'; Write-Output $result"') do set "OUTPUT=%%a"

REM Extract the day number from output
for /f "tokens=4" %%b in ("%OUTPUT%") do set "ACTUAL=%%b"

REM Compare expected vs actual
if "%ACTUAL%"=="%EXPECTED%" (
    call :LogEcho "  [PASS] Format '%FORMAT_DESC%': Expected: %EXPECTED%, Got: %ACTUAL%"
    set /a PASSED+=1
) else (
    call :LogEcho "  [FAIL] Format '%FORMAT_DESC%': Expected: %EXPECTED%, Got: %ACTUAL%"
    set /a FAILED+=1
)
goto :eof

REM Function to test pipeline input
:RunTestPipeline
set /a TOTAL+=1
set "TEST_DATE=%~1"
set "EXPECTED=%~2"

REM Run doy_calculator.ps1 with pipeline input and capture output
for /f "tokens=*" %%a in ('powershell.exe -ExecutionPolicy Bypass -Command "[datetime]'%TEST_DATE%' | & '%SCRIPT%'; Write-Output $result"') do set "OUTPUT=%%a"

REM Extract the day number from output
for /f "tokens=4" %%b in ("%OUTPUT%") do set "ACTUAL=%%b"

REM Compare expected vs actual
if "%ACTUAL%"=="%EXPECTED%" (
    call :LogEcho "  [PASS] Pipeline input: Expected: %EXPECTED%, Got: %ACTUAL%"
    set /a PASSED+=1
) else (
    call :LogEcho "  [FAIL] Pipeline input: Expected: %EXPECTED%, Got: %ACTUAL%"
    set /a FAILED+=1
)
goto :eof

REM Function to test Get-Help functionality
:RunTestHelp
set /a TOTAL+=1
set "HELP_TYPE=%~1"

REM Create temp PowerShell script to test help
echo $ErrorActionPreference = 'SilentlyContinue' > "%TEMP%\test_help.ps1"
echo $help = Get-Help '%SCRIPT%' %HELP_TYPE% 2^>$null ^| Out-String >> "%TEMP%\test_help.ps1"
echo if ($help -match 'SYNOPSIS') { Write-Output 'FOUND' } else { Write-Output 'NOT_FOUND' } >> "%TEMP%\test_help.ps1"

REM Run the temp script
for /f "tokens=*" %%a in ('powershell.exe -ExecutionPolicy Bypass -File "%TEMP%\test_help.ps1"') do set "RESULT=%%a"
del "%TEMP%\test_help.ps1"

REM Check if help was found
if "%RESULT%"=="FOUND" (
    call :LogEcho "  [PASS] Get-Help %HELP_TYPE% displays documentation"
    set /a PASSED+=1
) else (
    call :LogEcho "  [FAIL] Get-Help %HELP_TYPE% failed to display documentation"
    set /a FAILED+=1
)
goto :eof

REM Function to test -Verbose parameter (CmdletBinding feature)
:RunTestVerbose
set /a TOTAL+=1
set "TEST_DATE=%~1"
set "EXPECTED=%~2"

REM Run doy_calculator.ps1 with -Verbose parameter (tests that CmdletBinding works)
for /f "tokens=*" %%a in ('powershell.exe -ExecutionPolicy Bypass -Command "& '%SCRIPT%' -inputDate ([datetime]'%TEST_DATE%') -Verbose"') do set "OUTPUT=%%a"

REM Extract the day number from output
for /f "tokens=4" %%b in ("%OUTPUT%") do set "ACTUAL=%%b"

REM Compare expected vs actual
if "%ACTUAL%"=="%EXPECTED%" (
    call :LogEcho "  [PASS] -Verbose parameter accepted: Expected: %EXPECTED%, Got: %ACTUAL%"
    set /a PASSED+=1
) else (
    call :LogEcho "  [FAIL] -Verbose parameter: Expected: %EXPECTED%, Got: %ACTUAL%"
    set /a FAILED+=1
)
goto :eof

REM Function to log and echo a message
:LogEcho
set "MSG=%~1"
if "%MSG%"=="" (
    echo.
    echo. >> "%LOGFILE%"
) else (
    echo %MSG%
    echo %MSG% >> "%LOGFILE%"
)
goto :eof

REM ========================================
REM Main Test Execution
REM ========================================
:main

call :LogEcho "========================================"
call :LogEcho "Unit Tests for doy_calculator.ps1"
call :LogEcho "========================================"
call :LogEcho ""

REM Test 1: January 1st (Day 1)
call :LogEcho "Test 1: January 1st 2024 should be day 1"
call :RunTest "2024-01-01" "1"

REM Test 2: December 31st in non-leap year (Day 365)
call :LogEcho "Test 2: December 31st 2023 should be day 365"
call :RunTest "2023-12-31" "365"

REM Test 3: December 31st in leap year (Day 366)
call :LogEcho "Test 3: December 31st 2024 should be day 366"
call :RunTest "2024-12-31" "366"

REM Test 4: February 29th in leap year (Day 60)
call :LogEcho "Test 4: February 29th 2024 should be day 60"
call :RunTest "2024-02-29" "60"

REM Test 5: March 1st in leap year (Day 61)
call :LogEcho "Test 5: March 1st 2024 should be day 61"
call :RunTest "2024-03-01" "61"

REM Test 6: March 1st in non-leap year (Day 60)
call :LogEcho "Test 6: March 1st 2023 should be day 60"
call :RunTest "2023-03-01" "60"

REM Test 7: Mid-year date (July 4th)
call :LogEcho "Test 7: July 4th 2024 should be day 186"
call :RunTest "2024-07-04" "186"

REM Test 8: January 1st historical (2000)
call :LogEcho "Test 8: January 1st 2000 should be day 1"
call :RunTest "2000-01-01" "1"

REM Test 9: December 31st 2025 (non-leap)
call :LogEcho "Test 9: December 31st 2025 should be day 365"
call :RunTest "2025-12-31" "365"

REM Test 10: Valentine's Day 2024
call :LogEcho "Test 10: February 14th 2024 should be day 45"
call :RunTest "2024-02-14" "45"

REM ========================================
REM Test Optional Parameters
REM ========================================
call :LogEcho ""
call :LogEcho "========================================"
call :LogEcho "Testing Optional Parameters"
call :LogEcho "========================================"
call :LogEcho ""

REM Test 11: No parameter (should default to today)
call :LogEcho "Test 11: No parameter should default to current date"
call :RunTestNoParam

REM Test 12: Different date format - MM/DD/YYYY
call :LogEcho "Test 12: Date format MM/DD/YYYY"
call :RunTestFormat "01/01/2024" "1" "MM/DD/YYYY"

REM Test 13: Different date format - Month Day, Year
call :LogEcho "Test 13: Date format 'Month Day, Year'"
call :RunTestFormat "January 1, 2024" "1" "Month Day, Year"

REM Test 14: Different date format - YYYY-MM-DD (ISO)
call :LogEcho "Test 14: Date format YYYY-MM-DD (ISO)"
call :RunTestFormat "2024-07-04" "186" "YYYY-MM-DD"

REM Test 15: Different date format - DD-MMM-YYYY
call :LogEcho "Test 15: Date format DD-MMM-YYYY"
call :RunTestFormat "29-Feb-2024" "60" "DD-MMM-YYYY"

REM ========================================
REM Test Pipeline Input
REM ========================================
call :LogEcho ""
call :LogEcho "========================================"
call :LogEcho "Testing Pipeline Input"
call :LogEcho "========================================"
call :LogEcho ""

REM Test 16: Pipeline input
call :LogEcho "Test 16: Date via pipeline"
call :RunTestPipeline "2024-12-31" "366"

REM Test 17: Pipeline input with different date
call :LogEcho "Test 17: Pipeline with leap day"
call :RunTestPipeline "2024-02-29" "60"

REM ========================================
REM Test Help/Documentation Features
REM ========================================
call :LogEcho ""
call :LogEcho "========================================"
call :LogEcho "Testing Help and Documentation"
call :LogEcho "========================================"
call :LogEcho ""

REM Test 18: Get-Help (basic)
call :LogEcho "Test 18: Get-Help displays documentation"
call :RunTestHelp ""

REM Test 19: Get-Help -Detailed
call :LogEcho "Test 19: Get-Help -Detailed shows detailed help"
call :RunTestHelp "-Detailed"

REM Test 20: Get-Help -Examples
call :LogEcho "Test 20: Get-Help -Examples shows examples"
call :RunTestHelp "-Examples"

REM ========================================
REM Test Common Parameters (CmdletBinding)
REM ========================================
call :LogEcho ""
call :LogEcho "========================================"
call :LogEcho "Testing CmdletBinding Parameters"
call :LogEcho "========================================"
call :LogEcho ""

REM Test 21: -Verbose parameter
call :LogEcho "Test 21: -Verbose parameter works"
call :RunTestVerbose "2024-01-01" "1"

REM Display Summary
call :LogEcho ""
call :LogEcho "========================================"
call :LogEcho "Test Results Summary"
call :LogEcho "========================================"
call :LogEcho "Total Tests: %TOTAL%"
call :LogEcho "Passed:      %PASSED%"
call :LogEcho "Failed:      %FAILED%"
call :LogEcho ""

if %FAILED% GTR 0 (
    call :LogEcho "OVERALL RESULT: FAILED"
    endlocal
    exit /b 1
) else (
    call :LogEcho "OVERALL RESULT: ALL TESTS PASSED"
    endlocal
    exit /b 0
)
