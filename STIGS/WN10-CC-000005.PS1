<#
.SYNOPSIS
    This PowerShell script ensures that camera access from the lock screen is disabled.

.NOTES
    Author          : Brandon Perez
    LinkedIn        : https://www.linkedin.com/in/brandon-perez-71633823b/
    GitHub          : https://github.com/Brandonbpt
    Date Created    : 2025-03-04
    Last Modified   : 2025-03-04
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000005

.TESTED ON
    Date(s) Tested  : 03/04/2025
    Tested By       : Brandon Perez
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1.19041.5486

.USAGE
    This script disables camera access from the Windows lock screen by modifying the registry settings.

    Example syntax:
    PS C:\> .\Disable-LockScreenCamera.ps1

    Description:
    This script modifies the registry key `NoLockScreenCamera` under `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization`
    to disable camera access on the lock screen for Windows 10 systems. The script checks if the required registry path exists 
    and creates it if necessary, then sets the value to `1` to disable the camera.

    Requirements:
    - The script must be run as an administrator in PowerShell to modify the registry.
    - This script is designed to work with Windows 10. It may not be compatible with other versions of Windows.

    Notes:
    - A restart may be required for the changes to take effect.
    - Ensure that you have the necessary permissions to modify the registry on your system.
    - This script disables the camera on the lock screen, improving security by preventing unauthorized camera access.

    Parameters:
    - None

    Exit codes:
    - 0: Successfully completed the operation.
    - 1: Error during execution (e.g., insufficient privileges, registry modification failure).

#>

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$regName = "NoLockScreenCamera"
$regValue = 1

# Ensure the registry path exists, if not, create it
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}

# Set the value to disable lock screen camera access
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue

# Confirm the change
Write-Host "Lock screen camera access has been successfully disabled."
