\
Param(
    [string]$ImagePath = "$PSScriptRoot\..\assets\background.jpg"
)

$fullPath = (Resolve-Path $ImagePath).Path

if (!(Test-Path $fullPath)) {
    Write-Error "Background image not found at $fullPath"
    exit 1
}

Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name wallpaper -Value $fullPath

# Notify Windows of the change
RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters
Write-Host "Desktop background set to $fullPath"
