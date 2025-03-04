<#
.SYNOPSIS
    This PowerShell script ensures that the local drives aree prevented from sharing with Remote Desktop Session Hosts.

.NOTES
    Author          : Brandon Perez
    LinkedIn        : https://www.linkedin.com/in/brandon-perez-71633823b/
    GitHub          : ghttps://github.com/Brandonbpt
    Date Created    : 2025-09-09
    Last Modified   : 2025-09-09
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 03/04/2025
    Tested By       : Brandon Perez
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1.19041.5486

.USAGE
    This script prevents local drives from being shared with Remote Desktop Session Hosts by modifying the registry settings.

    Example syntax:
    PS C:\> .\Prevent-DriveRedirection.ps1

    Description:
    This script modifies the registry key `fDisableCdm` under `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services`
    to disable the ability for local drives to be shared during Remote Desktop sessions. This setting helps reduce the exposure of sensitive data by preventing drive redirection.

    Requirements:
    - The script must be run as an administrator in PowerShell to modify the registry.
    - This script is designed to work with Windows 10 systems.

    Notes:
    - A restart or a Group Policy refresh may be required for the changes to take effect.
    - This script ensures that drives cannot be redirected during Remote Desktop sessions, increasing security by preventing unauthorized data access.

    Parameters:
    - None

    Exit codes:
    - 0: Successfully prevented local drive redirection.
    - 1: Error during execution (e.g., insufficient privileges, registry modification failure).

#>

# Ensure script runs as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator." -ForegroundColor Red
    exit 1
}

# Define registry path and values
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$regName = "fDisableCdm"
$regValue = 1  # Prevent drive redirection

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Verify if the setting was applied successfully
$appliedValue = (Get-ItemProperty -Path $regPath -Name $regName).$regName
if ($appliedValue -eq $regValue) {
    Write-Host "Local drives will be prevented from sharing with Remote Desktop Session Hosts." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Failed to prevent drive redirection setting." -ForegroundColor Red
    exit 1
}
