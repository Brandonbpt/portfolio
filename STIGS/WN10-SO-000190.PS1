<#
.SYNOPSIS
    This PowerShell script ensures that Kerberos encryption is configured to prevent the use of DES and RC4 encryption suite.

.NOTES
    Author          : Brandon Perez
    LinkedIn        : https://www.linkedin.com/in/brandon-perez-71633823b/
    GitHub          : ghttps://github.com/Brandonbpt
    Date Created    : 2025-09-09
    Last Modified   : 2025-09-09
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000190

.TESTED ON
    Date(s) Tested  : 03/04/2025
    Tested By       : Brandon Perez
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1.19041.5486

 .USAGE
    To configure Kerberos encryption types, run the script in an Administrator PowerShell session:
    
    1. Open PowerShell as Administrator.
    2. Navigate to the script's directory.
    3. Run the script: `.\Configure-KerberosEncryption.ps1`
    
    EXPECTED OUTPUT:
    - "Kerberos encryption types successfully configured." (if applied correctly)
    - "Failed to apply the Kerberos encryption types setting." (if an issue occurs)
    
    NOTES:
    - Must be run as Administrator.
    - Ensures that only AES128, AES256, and future encryption types are enabled.
    - Modifies: `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters\SupportedEncryptionTypes`
    - Sets value to `0x7ffffff8 (2147483640)`.

#>
# Ensure script runs as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator." -ForegroundColor Red
    exit 1
}

# Define registry path and values
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters"
$regName = "SupportedEncryptionTypes"
$regValue = 0x7ffffff8  # 2147483640 (Only AES128, AES256, and future encryption types)

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Verify if the setting was applied successfully
$appliedValue = (Get-ItemProperty -Path $regPath -Name $regName).$regName
if ($appliedValue -eq $regValue) {
    Write-Host "Kerberos encryption types successfully configured." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Failed to apply the Kerberos encryption types setting." -ForegroundColor Red
    exit 1
}
