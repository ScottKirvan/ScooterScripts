# Day of Year Calculator

Calculates the day of the year (1-365 or 1-366 for leap years) for a given date.

## Two Ways to Use This Script

### Option 1: Friendly Wrapper - doy.ps1 (RECOMMENDED)
A user-friendly wrapper with enhanced error handling:

```powershell
# Use today's date
.\doy.ps1

# Specify a date
.\doy.ps1 "2024-01-01"
.\doy.ps1 -inputDate "2024-12-31"

# Get help - these all work!
.\doy.ps1 -help
.\doy.ps1 -h
.\doy.ps1 help
```

**Why use the wrapper?**
- ✓ Accepts common help flags: `-help`, `-h`, `--help`, `-?`
- ✓ Better error messages for invalid parameters (like `-xyz`)
- ✓ Simpler to use for command-line users
- ✓ Handles erroneous command line arguments gracefully

### Option 2: Direct Script - doy_calculator.ps1
The main script with full PowerShell features:

```powershell
.\doy_calculator.ps1
.\doy_calculator.ps1 -inputDate "2024-01-01"

# For help, use Get-Help (PowerShell standard)
Get-Help .\doy_calculator.ps1
Get-Help .\doy_calculator.ps1 -Detailed
```

## Examples

```powershell
PS> .\doy.ps1
Day of Year: 295

PS> .\doy.ps1 "2024-01-01"
Day of Year: 1

PS> .\doy.ps1 -inputDate "2024-12-31"
Day of Year: 366

PS> .\doy.ps1 -help
[Shows detailed help documentation]

PS> .\doy.ps1 -xyz
ERROR: Invalid parameter or argument.

This script only accepts: -inputDate <date>
[Shows usage examples]
```

## Testing

Run the unit tests:
```cmd
unittest.bat
```

All 21 unit tests cover:
- Basic date calculations
- Leap years
- Different date formats
- Pipeline input
- Help documentation
- Error handling

## Error Handling

Both scripts provide helpful error messages:

```powershell
PS> .\doy.ps1 "not-a-date"
ERROR: Invalid date format provided.

USAGE:
  .\doy_calculator.ps1 [-inputDate <date>]

EXAMPLES:
  .\doy_calculator.ps1                      # Uses today's date
  .\doy_calculator.ps1 -inputDate '2024-01-01'
  .\doy_calculator.ps1 '2024-12-31'

For detailed help, run: Get-Help .\doy_calculator.ps1 -Detailed
```

## Getting Help

**With doy.ps1 (wrapper):**
```powershell
.\doy.ps1 -help          # Shows help
.\doy.ps1 -h             # Shows help
.\doy.ps1 --help         # Shows help
Get-Help .\doy.ps1       # PowerShell standard
```

**With doy_calculator.ps1 (direct):**
```powershell
Get-Help .\doy_calculator.ps1           # Basic help
Get-Help .\doy_calculator.ps1 -Detailed # Detailed documentation
Get-Help .\doy_calculator.ps1 -Examples # Usage examples
```

## Files

- **doy.ps1** - User-friendly wrapper (recommended for most users)
- **doy_calculator.ps1** - Main script with full PowerShell integration
- **unittest.bat** - Comprehensive test suite (21 tests)
- **README.md** - This file
