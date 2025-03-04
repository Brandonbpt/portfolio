<#
.SYNOPSIS
    This PowerShell script ensures that Windows Telemetry can't be configured to Full.

.NOTES
    Author          : Brandon Perez
    LinkedIn        : https://www.linkedin.com/in/brandon-perez-71633823b/
    GitHub          : ghttps://github.com/Brandonbpt
    Date Created    : 2025-09-09
    Last Modified   : 2025-09-09
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC0000205

.TESTED ON
    Date(s) Tested  : 03/04/2025
    Tested By       : Brandon Perez
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1.19041.5486

.USAGE
.DESCRIPTION
    This script ensures Windows Telemetry is not set to "Full" by modifying the registry setting  
    "AllowTelemetry" to either **0 (Security)** or **1 (Basic)** as required for compliance.  

.PARAMETER None
    This script does not take any parameters.

.EXAMPLE
    Open PowerShell as Administrator and run:
    PS C:\> .\Set-TelemetryLevel.ps1

    Expected Output:
    "Telemetry level successfully set to 1."

.NOTES
    - **Must be run as Administrator** to modify registry settings.  
    - The script creates the registry path if it does not exist.  
    - Default setting applies "Basic" telemetry (1); change `$regValue` to `0` for "Security".  
    - Verifies the applied setting and provides success or failure feedback.  
#>

# CODE
