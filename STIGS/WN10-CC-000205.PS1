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
    This script ensures that Windows Telemetry is not set to "Full" by modifying the registry settings.

    Example syntax:
    PS C:\> .\Set-TelemetryLevel.ps1

    Description:
    This script modifies the registry key `AllowTelemetry` under  
    `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection`  
    to comply with STIG ID: WN10-CC-000205.  
    The script ensures that Windows Telemetry is set to `0` (Security) or `1` (Basic)  
    to prevent excessive data collection while maintaining necessary system diagnostics.  
    If the registry path does not exist, the script creates it before applying the setting.

    Requirements:
    - The script must be run as an administrator in PowerShell to modify the registry.  
    - Designed for Windows 10. Compatibility with other versions is not guaranteed.

    Notes:
    - A system restart may be required for changes to take effect.  
    - Ensure you have the necessary permissions to modify registry settings.  
    - If Windows Analytics is used, the value may be set to `2` (Enhanced) per organizational policy.

    Parameters:
    - None

    Exit codes:
    - 0: Successfully applied the registry setting.  
    - 1: Error during execution (e.g., insufficient privileges, registry modification failure).

#>

# CODE
