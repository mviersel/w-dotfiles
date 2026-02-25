\
<#
    Master setup script for new Windows install.
    Run this as Administrator in PowerShell:

        Set-ExecutionPolicy Bypass -Scope Process -Force
        .\setup.ps1
#>

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

Write-Host "== Windows dotfiles setup starting =="

# 1) Disable PS1 security so other scripts can run freely
Write-Host "Step 1: Setting execution policy..."
& "$root\windows\disable-ps1-security.ps1"

# 2) Install Winget packages
Write-Host "Step 2: Installing Winget packages..."
& "$root\install\install-winget.ps1"

# 3) Install global Node/NPM packages
Write-Host "Step 3: Installing global Node/NPM packages..."
& "$root\install\install-node.ps1"

# 5) Enable old context menu
Write-Host "Step 5: Enabling old context menu..."
& "$root\enable-old-context-menu.ps1"

Write-Host "== All done! You may want to reboot to ensure all settings are applied. =="
