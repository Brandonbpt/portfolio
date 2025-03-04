<#
.SYNOPSIS
    This PowerShell script ensures that the convenience PIN for Windows 10 is disabled.

.NOTES
    Author          : Brandon Perez
    LinkedIn        : https://www.linkedin.com/in/brandon-perez-71633823b/
    GitHub          : ghttps://github.com/Brandonbpt
    Date Created    : 2025-09-09
    Last Modified   : 2025-09-09
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000370

.TESTED ON
    Date(s) Tested  : 03/04/2025
    Tested By       : Brandon Perez
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1.19041.5486

.USAGE
    This script disables the convenience PIN sign-in for Windows 10 domain users by modifying the registry settings.

    Example syntax:
    PS C:\> .\Disable-ConveniencePINSignIn.ps1

    Description:
    This script modifies the registry key `AllowDomainPINLogon` under `HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System` 
    to disable the convenience PIN sign-in option. This action prevents domain users from using a PIN to sign in to the system.

    Requirements:
    - The script must be run as an administrator in PowerShell to modify the registry.
    - This script is designed to work on Windows 10 systems that support the convenience PIN feature.

    Notes:
    - A restart may be required for the changes to take effect.
    - Ensure that the system is a domain member and that the convenience PIN sign-in feature is not needed before applying this script.
    - This script helps improve security by preventing the use of a convenience PIN for authentication.

    Parameters:
    - None

    Exit codes:
    - 0: Successfully disabled the convenience PIN sign-in.
    - 1: Error during execution (e.g., insufficient privileges, registry modification failure).

#>

# Ensure script runs as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator." -ForegroundColor Red
    exit 1
}

# Define registry path and values
$regPath = "HKLM:\Software\Policies\Microsoft\Windows\System"
$regName = "AllowDomainPINLogon"
$regValue = 0  # Disable Convenience PIN sign-in

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Verify if the setting was applied successfully
$appliedValue = (Get-ItemProperty -Path $regPath -Name $regName).$regName
if ($appliedValue -eq $regValue) {
    Write-Host "Convenience PIN sign-in has been successfully disabled." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Failed to disable convenience PIN sign-in." -ForegroundColor Red
    exit 1
}

