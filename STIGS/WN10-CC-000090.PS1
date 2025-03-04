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
