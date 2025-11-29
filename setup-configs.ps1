# setup-configs.ps1
# Kopieert configs vanuit ./configs naar de juiste locaties in je home

$home = $HOME
$repoRoot = $PSScriptRoot

# 1) Git config
$srcGitConfig  = Join-Path $repoRoot "configs/git/.gitconfig"
$dstGitConfig  = Join-Path $home ".gitconfig"

if (Test-Path $srcGitConfig) {
    Write-Host "Kopieer Git config..."
    Copy-Item $srcGitConfig $dstGitConfig -Force
}

# 2) PowerShell profiel
$srcPsProfile  = Join-Path $repoRoot "configs/powershell/Microsoft.PowerShell_profile.ps1"
$psDir         = Join-Path $home "Documents\PowerShell"
$dstPsProfile  = Join-Path $psDir "Microsoft.PowerShell_profile.ps1"

if (Test-Path $srcPsProfile) {
    if (-not (Test-Path $psDir)) {
        New-Item -ItemType Directory -Path $psDir | Out-Null
    }
    Write-Host "Kopieer PowerShell profiel..."
    Copy-Item $srcPsProfile $dstPsProfile -Force
}

# 3) VS Code settings
$srcVsCodeSettings = Join-Path $repoRoot "configs/vscode/settings.json"
$vsCodeDir         = Join-Path $home "AppData\Roaming\Code\User"
$dstVsCodeSettings = Join-Path $vsCodeDir "settings.json"

if (Test-Path $srcVsCodeSettings) {
    if (-not (Test-Path $vsCodeDir)) {
        New-Item -ItemType Directory -Path $vsCodeDir -Force | Out-Null
    }
    Write-Host "Kopieer VS Code settings..."
    Copy-Item $srcVsCodeSettings $dstVsCodeSettings -Force
}

Write-Host "Klaar met configs kopiëren."
