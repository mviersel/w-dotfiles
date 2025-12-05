\
Param(
    [string]$ListPath = "$PSScriptRoot\winget-list.txt"
)

if (!(Test-Path $ListPath)) {
    Write-Error "Winget list file not found at $ListPath"
    exit 1
}

$packages = Get-Content $ListPath | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg..."
    winget install --id $pkg -e --accept-source-agreements --accept-package-agreements
}
