<#
.SYNOPSIS
    This PowerShell script ensures that the Windows 10 systems use a BitLocker PIN for pre-boot authentication..

.NOTES
    Author          : Brandon Perez
    LinkedIn        : https://www.linkedin.com/in/brandon-perez-71633823b/
    GitHub          : ghttps://github.com/Brandonbpt
    Date Created    : 2025-09-09
    Last Modified   : 2025-09-09
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000031

.TESTED ON
    Date(s) Tested  : 03/04/2025
    Tested By       : Brandon Perez
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1.19041.5486

.USAGE
   .USAGE
    This script configures BitLocker to require a PIN for pre-boot authentication by modifying registry settings.

    Example syntax:
    PS C:\> .\Configure-BitLockerPIN.ps1

    Description:
    This script modifies the registry keys under `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\FVE` to enforce the use of a BitLocker PIN for pre-boot authentication. 
    The script ensures that the required settings for TPM PIN and TPM key PIN are enabled for enhanced security.

    Requirements:
    - The script must be run as an administrator in PowerShell to modify the registry.
    - This script is designed to work on Windows 10 systems that support BitLocker.
    
    Notes:
    - A restart may be required for the changes to take effect.
    - Ensure that BitLocker is enabled and the system meets hardware requirements for TPM.
    - This script enforces a TPM PIN for pre-boot authentication, increasing data protection during startup.

    Parameters:
    - None

    Exit codes:
    - 0: Successfully configured BitLocker pre-boot PIN authentication.
    - 1: Error during execution (e.g., insufficient privileges, registry modification failure).

#>

# Ensure script runs as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator." -ForegroundColor Red
    exit 1
}

# Define registry path and values for BitLocker pre-boot PIN authentication
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValues = @{
    "UseAdvancedStartup" = 1
    "UseTPMPIN" = 1
    "UseTPMKeyPIN" = 1
}

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry values to enable BitLocker pre-boot PIN authentication
foreach ($regName in $regValues.Keys) {
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValues[$regName] -Type DWord
}

# Verify if the settings were applied successfully
$applyResults = $true
foreach ($regName in $regValues.Keys) {
    $appliedValue = (Get-ItemProperty -Path $regPath -Name $regName).$regName
    if ($appliedValue -ne $regValues[$regName]) {
        Write-Host "Failed to apply the setting for $regName." -ForegroundColor Red
        $applyResults = $false
    }
}

# Final result message
if ($applyResults) {
    Write-Host "BitLocker pre-boot PIN authentication successfully configured." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Failed to apply one or more BitLocker settings." -ForegroundColor Red
    exit 1
}

