<#
.SYNOPSIS
  Simple Windows "stow-like" linker for:
  - .\localappdata\*  ->  $env:LOCALAPPDATA\<name>
  - .\.config\*       ->  $HOME\.config\<name>

.DESCRIPTION
  Creates directory symlinks for each direct child folder.
  Skips if destination already exists (folder, file, or link).
  Only creates new links.

.NOTES
  - Prefer running in an elevated PowerShell if your system disallows symlinks
    for non-admin users.
  - Requires Windows 10/11. Symlinks usually work without admin if
    Developer Mode is enabled.
#>

[CmdletBinding()]
param(
  # Root of your dotfiles repo; defaults to the folder where the script lives
  [string]$RepoRoot = $PSScriptRoot,

  # Show what would happen, without making changes
  [switch]$WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-Dir([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    if ($WhatIf) { Write-Host "Would create directory: $Path" -ForegroundColor DarkGray }
    else { New-Item -ItemType Directory -Path $Path | Out-Null }
  }
}

function Link-ChildFolders {
  param(
    [Parameter(Mandatory)][string]$SourceBase,
    [Parameter(Mandatory)][string]$DestBase
  )

  if (-not (Test-Path -LiteralPath $SourceBase)) {
    Write-Host "Skip (source missing): $SourceBase" -ForegroundColor Yellow
    return
  }

  Ensure-Dir $DestBase

  # Only direct child directories
  Get-ChildItem -LiteralPath $SourceBase -Directory | ForEach-Object {
    $src = $_.FullName
    $name = $_.Name
    $dst = Join-Path $DestBase $name

    if (Test-Path -LiteralPath $dst) {
      Write-Host "Skip (exists): $dst" -ForegroundColor Yellow
      return
    }

    if ($WhatIf) {
      Write-Host "Would link: $dst -> $src" -ForegroundColor Cyan
      return
    }

    try {
      New-Item -ItemType SymbolicLink -Path $dst -Target $src | Out-Null
      Write-Host "Linked: $dst -> $src" -ForegroundColor Green
    } catch {
      Write-Host "FAILED linking: $dst -> $src" -ForegroundColor Red
      Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
      Write-Host "Tip: run PowerShell as Administrator or enable Developer Mode (Settings > For developers)." -ForegroundColor DarkYellow
    }
  }
}

$repoLocalAppData = Join-Path $RepoRoot "localappdata"
$repoConfig       = Join-Path $RepoRoot ".config"

$destLocalAppData = $env:LOCALAPPDATA
$destConfig       = Join-Path $HOME ".config"

Write-Host "RepoRoot: $RepoRoot" -ForegroundColor DarkGray
Write-Host "Mapping:" -ForegroundColor DarkGray
Write-Host "  $repoLocalAppData  ->  $destLocalAppData" -ForegroundColor DarkGray
Write-Host "  $repoConfig        ->  $destConfig" -ForegroundColor DarkGray
Write-Host ""

Link-ChildFolders -SourceBase $repoLocalAppData -DestBase $destLocalAppData
Link-ChildFolders -SourceBase $repoConfig       -DestBase $destConfig

[CmdletBinding()]
param(
  [string]$RepoRoot = $PSScriptRoot,
  [switch]$WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-Dir([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    if ($WhatIf) {
      Write-Host "Would create directory: $Path" -ForegroundColor DarkGray
    } else {
      New-Item -ItemType Directory -Path $Path | Out-Null
    }
  }
}

function Link-ChildFolders {
  param(
    [Parameter(Mandatory)][string]$SourceBase,
    [Parameter(Mandatory)][string]$DestBase
  )

  if (-not (Test-Path -LiteralPath $SourceBase)) {
    Write-Host "Skip (source missing): $SourceBase" -ForegroundColor Yellow
    return
  }

  Ensure-Dir $DestBase

  Get-ChildItem -LiteralPath $SourceBase -Directory | ForEach-Object {
    $src  = $_.FullName
    $name = $_.Name
    $dst  = Join-Path $DestBase $name

    if (Test-Path -LiteralPath $dst) {
      Write-Host "Skip (exists): $dst" -ForegroundColor Yellow
      return
    }

    if ($WhatIf) {
      Write-Host "Would link: $dst -> $src" -ForegroundColor Cyan
      return
    }

    try {
      New-Item -ItemType SymbolicLink -Path $dst -Target $src | Out-Null
      Write-Host "Linked: $dst -> $src" -ForegroundColor Green
    } catch {
      Write-Host "FAILED linking: $dst -> $src" -ForegroundColor Red
      Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
    }
  }
}

# Repo folders
$repoLocalAppData = Join-Path $RepoRoot "localappdata"
$repoConfig       = Join-Path $RepoRoot ".config"
$repoHome         = Join-Path $RepoRoot "home"

# Destination folders
$destLocalAppData = $env:LOCALAPPDATA
$destConfig       = Join-Path $HOME ".config"
$destHome         = $HOME

Write-Host "RepoRoot: $RepoRoot" -ForegroundColor DarkGray
Write-Host "Mappings:" -ForegroundColor DarkGray
Write-Host "  $repoLocalAppData -> $destLocalAppData" -ForegroundColor DarkGray
Write-Host "  $repoConfig       -> $destConfig" -ForegroundColor DarkGray
Write-Host "  $repoHome         -> $destHome" -ForegroundColor DarkGray
Write-Host ""

Link-ChildFolders -SourceBase $repoLocalAppData -DestBase $destLocalAppData
Link-ChildFolders -SourceBase $repoConfig       -DestBase $destConfig
Link-ChildFolders -SourceBase $repoHome         -DestBase $destHome
