<#
.SYNOPSIS
    This PowerShell script  must be configured to audit Account Management - User Account Management failures.

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

.SYNOPSIS
    Configures Windows audit policy to enable logging of User Account Management failures.

.DESCRIPTION
    This script ensures that Windows logs failure events related to User Account Management.  
    It modifies the audit policy using 'auditpol' to comply with STIG ID: WN10-AU-000035.  
    The script must be run with Administrator privileges.

.PARAMETER None
    This script does not require any parameters.

.EXAMPLE
    Open PowerShell as Administrator and run:
    PS C:\> .\Enable-UserAccountManagementAudit.ps1

    Expected Output:
    "Audit User Account Management - Failure has been successfully enabled."

.NOTES
    - Ensure you run this script as an Administrator.
    - It checks the applied settings and provides success or failure feedback.
    - If the audit policy is already configured, it will not make unnecessary changes.

#>
# Ensure script runs as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator." -ForegroundColor Red
    exit 1
}

# Enable "Audit User Account Management - Failure"
Write-Host "Configuring audit policy for User Account Management failures..."
auditpol /set /subcategory:"User Account Management" /failure:enable

# Verify if the setting was applied successfully
$AuditSetting = auditpol /get /subcategory:"User Account Management"

if ($AuditSetting -match "Failure.*Enabled") {
    Write-Host "Audit User Account Management - Failure has been successfully enabled." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Failed to apply the audit policy setting." -ForegroundColor Red
    exit 1
}
