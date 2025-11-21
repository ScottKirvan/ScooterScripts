<#
.SYNOPSIS
    Calculates the day of the year for a given date.

.DESCRIPTION
    The Day of Year Calculator takes a date as input and returns the day number
    within that year (1-365 for regular years, 1-366 for leap years).

    Day 1 is January 1st.
    Day 365/366 is December 31st (depending on leap year).

.PARAMETER inputDate
    The date for which to calculate the day of year.
    Accepts any valid DateTime object or string that can be parsed as a date.
    If not provided, defaults to the current date.

.EXAMPLE
    .\doy_calculator.ps1 -inputDate "2024-01-01"
    Returns: Day of Year: 1

.EXAMPLE
    .\doy_calculator.ps1 -inputDate "2024-12-31"
    Returns: Day of Year: 366 (2024 is a leap year)

.EXAMPLE
    .\doy_calculator.ps1
    Returns the day of year for today's date

.NOTES
    File Name      : doy_calculator.ps1
    Author         : Scott Kirvan
    Prerequisite   : PowerShell 5.1 or higher

.LINK
    https://docs.microsoft.com/en-us/dotnet/api/system.datetime.dayofyear
#>

[CmdletBinding()]
param (
    [Parameter(
        Position = 0,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
        HelpMessage = "Enter a date to calculate the day of year"
    )]
    $inputDate
)

begin {
    # Set error action preference
    $ErrorActionPreference = "Stop"

    # Check for common help arguments
    $helpArgs = @('-h', '--h', '-help', '--help', '/h', '/help', '/?', '-?')
    if ($PSBoundParameters.Keys | Where-Object { $_ -in $helpArgs }) {
        Get-Help $PSCommandPath -Detailed
        exit 0
    }

    # Function to show short help
    function Show-ShortHelp {
        param([string]$ErrorMsg = "Invalid date format provided.")
        Write-Host "ERROR: $ErrorMsg" -ForegroundColor Red
        Write-Host ""
        Write-Host "USAGE:" -ForegroundColor Yellow
        Write-Host "  .\doy_calculator.ps1 [-inputDate <date>]"
        Write-Host ""
        Write-Host "EXAMPLES:" -ForegroundColor Yellow
        Write-Host "  .\doy_calculator.ps1                      # Uses today's date"
        Write-Host "  .\doy_calculator.ps1 -inputDate '2024-01-01'"
        Write-Host "  .\doy_calculator.ps1 '2024-12-31'"
        Write-Host ""
        Write-Host "For detailed help, run: Get-Help .\doy_calculator.ps1 -Detailed" -ForegroundColor Cyan
    }

    # If no input provided, use today's date
    if ($null -eq $inputDate -or $inputDate -eq '') {
        $inputDate = Get-Date
    }
    # Try to convert input to DateTime if it's not already
    elseif ($inputDate -isnot [datetime]) {
        try {
            $inputDate = [datetime]::Parse($inputDate)
        }
        catch {
            Show-ShortHelp
            exit 1
        }
    }
}

process {
    try {
        # Calculate the day of year using the built-in DateTime property
        $dayOfYear = $inputDate.DayOfYear

        # Validate the result is within expected range
        $daysInYear = if ([datetime]::IsLeapYear($inputDate.Year)) { 366 } else { 365 }

        if ($dayOfYear -lt 1 -or $dayOfYear -gt $daysInYear) {
            throw "Calculated day of year ($dayOfYear) is out of valid range (1-$daysInYear)"
        }

        # Output the result
        Write-Output "Day of Year: $dayOfYear"
    }
    catch {
        # Catch any errors
        Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        Write-Host "For help, run: Get-Help .\doy_calculator.ps1" -ForegroundColor Cyan
        exit 1
    }
}

end {
    # Cleanup if needed (none required for this simple script)
}
