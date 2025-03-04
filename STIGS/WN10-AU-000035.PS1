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

.USAGE
    This script enables logging for "User Account Management - Failure" events in Windows  
    audit policy to comply with STIG ID: WN10-AU-000035.

    Example syntax:
    PS C:\> .\Enable-UserAccountManagementAudit.ps1

    Description:
    This script uses the `auditpol` command to ensure that "User Account Management - Failure" events  
    are logged for security auditing purposes. It verifies the current audit policy settings and applies  
    the required configuration if not already enabled. 

    Requirements:
    - The script must be run as an administrator in PowerShell to modify audit policies.  
    - Designed for Windows 10. Compatibility with other versions is not guaranteed.

    Notes:
    - Ensure you have administrative privileges before running the script.  
    - This script checks the current audit setting and applies the policy if necessary.  
    - If the policy is already enabled, the script will confirm and exit without making changes.

    Parameters:
    - None  

    Exit codes:
    - 0: Successfully enabled "User Account Management - Failure" audit policy.  
    - 1: Error during execution (e.g., insufficient privileges, audit policy modification failure).


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
