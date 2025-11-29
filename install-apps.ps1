# install-apps.ps1
# Leest apps.txt en installeert alles met winget

$appsFile = Join-Path $PSScriptRoot "apps.txt"

if (-not (Test-Path $appsFile)) {
    Write-Error "apps.txt niet gevonden in $PSScriptRoot"
    exit 1
}

$apps = Get-Content $appsFile | Where-Object { $_ -and -not $_.StartsWith("#") }

foreach ($app in $apps) {
    Write-Host "Installeer: $app"
    winget install --id $app -e --silent
}
