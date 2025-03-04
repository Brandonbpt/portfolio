<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Brandon Perez
    LinkedIn        : https://www.linkedin.com/in/brandon-perez-71633823b/
    GitHub          : ghttps://github.com/Brandonbpt
    Date Created    : 2025-09-09
    Last Modified   : 2025-09-09
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000295

.TESTED ON
    Date(s) Tested  : 03/04/2025
    Tested By       : Brandon Perez
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1.19041.5486

.USAGE
    This script prevents attachments from being downloaded from RSS feeds by modifying the registry settings.

    Example syntax:
    PS C:\> .\Disable-RSSFeedAttachments.ps1

    Description:
    This script modifies the registry key `DisableEnclosureDownload` under `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds`
    to prevent the downloading of attachments from RSS feeds. This helps prevent potentially insecure attachments from being automatically downloaded.

    Requirements:
    - The script must be run as an administrator in PowerShell to modify the registry.
    - This script is designed to work on Windows 10 systems with Internet Explorer or RSS feed capabilities enabled.

    Notes:
    - A restart may be required for the changes to take effect.
    - Ensure that this policy aligns with the organization's requirements before disabling the downloading of RSS feed attachments.
    - This script enhances security by blocking potentially unsafe attachments from being downloaded.

    Parameters:
    - None

    Exit codes:
    - 0: Successfully disabled downloading of attachments from RSS feeds.
    - 1: Error during execution (e.g., insufficient privileges, registry modification failure).

#>

# Ensure script runs as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator." -ForegroundColor Red
    exit 1
}

# Define registry path and values
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds"
$regName = "DisableEnclosureDownload"
$regValue = 1  # Prevent downloading of enclosures (attachments)

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Verify if the setting was applied successfully
$appliedValue = (Get-ItemProperty -Path $regPath -Name $regName).$regName
if ($appliedValue -eq $regValue) {
    Write-Host "Downloading attachments from RSS feeds has been successfully disabled." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Failed to disable attachment downloads from RSS feeds." -ForegroundColor Red
    exit 1
}
