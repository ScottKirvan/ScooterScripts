<#
.SYNOPSIS
    Wrapper for doy_calculator.ps1 with enhanced error handling.

.DESCRIPTION
    This is a user-friendly wrapper that catches parameter binding errors
    and displays helpful messages. It calls doy_calculator.ps1 internally.

.PARAMETER inputDate
    The date for which to calculate the day of year.

.EXAMPLE
    .\doy.ps1
    .\doy.ps1 "2024-01-01"
    .\doy.ps1 -help      # This will show help instead of error!
#>

param(
    [Parameter(ValueFromRemainingArguments=$true)]
    $Arguments
)

$ErrorActionPreference = "Stop"

# Check for help arguments
$helpArgs = @('-h', '--h', '-help', '--help', '/h', '/help', '/?', '-?', 'help', '--help')
foreach ($arg in $Arguments) {
    if ($arg -in $helpArgs) {
        Get-Help "$PSScriptRoot\doy_calculator.ps1" -Detailed
        exit 0
    }
}

# Call the actual script with error handling
$scriptPath = Join-Path $PSScriptRoot "doy_calculator.ps1"

try {
    if ($null -eq $Arguments -or $Arguments.Count -eq 0) {
        # No arguments - call with no parameters
        & $scriptPath
    }
    elseif ($Arguments.Count -eq 1 -and $Arguments[0] -notlike '-*') {
        # Single positional argument
        & $scriptPath -inputDate $Arguments[0]
    }
    else {
        # Pass all arguments
        & $scriptPath @Arguments
    }
}
catch [System.Management.Automation.ParameterBindingException] {
    Write-Host "ERROR: Invalid parameter or argument." -ForegroundColor Red
    Write-Host ""
    Write-Host "This script only accepts: -inputDate <date>" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "USAGE:" -ForegroundColor Yellow
    Write-Host "  .\doy.ps1 [date]"
    Write-Host "  .\doy.ps1 -inputDate <date>"
    Write-Host ""
    Write-Host "EXAMPLES:" -ForegroundColor Yellow
    Write-Host "  .\doy.ps1                    # Uses today's date"
    Write-Host "  .\doy.ps1 '2024-01-01'"
    Write-Host "  .\doy.ps1 -inputDate '2024-12-31'"
    Write-Host "  .\doy.ps1 -help              # Show help"
    Write-Host ""
    Write-Host "For detailed help, run: Get-Help .\doy_calculator.ps1 -Detailed" -ForegroundColor Cyan
    exit 1
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
