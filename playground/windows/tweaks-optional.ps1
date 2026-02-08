\
Write-Host "Applying optional Windows tweaks..."

# --- Dark mode ---
try {
    $personalizePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    if (!(Test-Path $personalizePath)) {
        New-Item -Path $personalizePath -Force | Out-Null
    }
    Set-ItemProperty -Path $personalizePath -Name AppsUseLightTheme -Value 0 -Type DWord
    Set-ItemProperty -Path $personalizePath -Name SystemUsesLightTheme -Value 0 -Type DWord
    Write-Host "Dark mode enabled."
} catch {
    Write-Warning "Failed to set dark mode: $_"
}

# --- Taskbar left alignment (Windows 11) ---
try {
    $advPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    Set-ItemProperty -Path $advPath -Name TaskbarAl -Value 0 -Type DWord
    Write-Host "Taskbar aligned to the left."
} catch {
    Write-Warning "Failed to align taskbar: $_"
}

# --- Hide search box on taskbar ---
try {
    $searchPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
    if (!(Test-Path $searchPath)) {
        New-Item -Path $searchPath -Force | Out-Null
    }
    Set-ItemProperty -Path $searchPath -Name SearchboxTaskbarMode -Value 0 -Type DWord
    Write-Host "Search box on taskbar disabled."
} catch {
    Write-Warning "Failed to modify search box: $_"
}

# --- Auto-hide taskbar ---
try {
    # Read existing settings so we don't nuke everything
    $stuckPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3"
    $current = (Get-ItemProperty -Path $stuckPath -Name Settings).Settings

    # Byte index 8 contains the taskbar flags. Set bit 2 for auto-hide.
    $bytes = [byte[]]$current
    $bytes[8] = $bytes[8] -bor 0x02

    Set-ItemProperty -Path $stuckPath -Name Settings -Value $bytes
    Write-Host "Taskbar auto-hide enabled."
} catch {
    Write-Warning "Failed to enable taskbar auto-hide: $_"
}

# --- Lockscreen wallpaper same as desktop wallpaper ---
try {
    $desktopPath = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name wallpaper).wallpaper
    if (Test-Path $desktopPath) {
        $lockPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lock Screen"
        if (!(Test-Path $lockPath)) {
            New-Item -Path $lockPath -Force | Out-Null
        }
        Set-ItemProperty -Path $lockPath -Name LandscapeAssetPath -Value $desktopPath
        Write-Host "Lock screen background set to same as desktop: $desktopPath"
    } else {
        Write-Warning "Desktop wallpaper path not found; skipping lock screen background sync."
    }
} catch {
    Write-Warning "Failed to set lock screen background: $_"
}

Write-Host "Optional tweaks applied. Restarting Explorer..."
Stop-Process -Name explorer -Force
