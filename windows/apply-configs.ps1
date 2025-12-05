$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$configRoot = Join-Path $root "..\config"

Write-Host "Applying app configs from $configRoot"

# --- GlazeWM ---
try {
    $glazeConfigSrc = Join-Path $configRoot "glazewm\config.yaml"
    if (Test-Path $glazeConfigSrc) {
        $glazeConfigDir = Join-Path $env:LOCALAPPDATA "glaze-wm"
        if (!(Test-Path $glazeConfigDir)) {
            New-Item -Path $glazeConfigDir -ItemType Directory -Force | Out-Null
        }

        $glazeConfigDst = Join-Path $glazeConfigDir "config.yaml"
        Copy-Item $glazeConfigSrc $glazeConfigDst -Force

        Write-Host "GlazeWM config applied to $glazeConfigDst"
    } else {
        Write-Host "GlazeWM config not found at $glazeConfigSrc, skipping."
    }
} catch {
    Write-Warning "Failed to apply GlazeWM config: $_"
}

Write-Host "Config application done."
