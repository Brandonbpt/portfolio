<#
.SYNOPSIS
    This PowerShell script ensures that the Application Compatibility Program Inventory is prevented from collecting data and sending the information to Microsoft.

.NOTES
    Author          : Brandon Perez
    LinkedIn        : https://www.linkedin.com/in/brandon-perez-71633823b/
    GitHub          : ghttps://github.com/Brandonbpt
    Date Created    : 2025-09-09
    Last Modified   : 2025-09-09
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000175

.TESTED ON
    Date(s) Tested  : 03/04/2025
    Tested By       : Brandon Perez
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1.19041.5486

.USAGE
    This script disables the Application Compatibility Program Inventory from collecting and sending data to Microsoft by modifying the registry settings.

    Example syntax:
    PS C:\> .\Disable-AppCompatInventory.ps1

    Description:
    This script modifies the registry key `DisableInventory` under `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppCompat` 
    to prevent the Application Compatibility Program Inventory from collecting data and sending it to Microsoft. This helps ensure that no sensitive 
    system information is inadvertently sent to external vendors.

    Requirements:
    - The script must be run as an administrator in PowerShell to modify the registry.
    - This script is designed to work on Windows 10 systems with the Application Compatibility feature enabled.

    Notes:
    - A restart may be required for the changes to take effect.
    - Ensure that the system does not require the Application Compatibility Program Inventory before disabling it.
    - This script helps enhance security by preventing unnecessary data collection and transmission to Microsoft.

    Parameters:
    - None

    Exit codes:
    - 0: Successfully disabled the Application Compatibility Program Inventory.
    - 1: Error during execution (e.g., insufficient privileges, registry modification failure).
 
#>

# Ensure script runs as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator." -ForegroundColor Red
    exit 1
}

# Define registry path and values
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"
$regName = "DisableInventory"
$regValue = 1  # Disable Application Compatibility Program Inventory

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Verify if the setting was applied successfully
$appliedValue = (Get-ItemProperty -Path $regPath -Name $regName).$regName
if ($appliedValue -eq $regValue) {
    Write-Host "Application Compatibility Program Inventory has been successfully disabled." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Failed to disable the Application Compatibility Program Inventory." -ForegroundColor Red
    exit 1
}

