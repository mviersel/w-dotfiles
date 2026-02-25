# Pad naar je dotfiles repo
$Dotfiles = "$HOME\dotfiles"

# Lijst van bestanden/mappen die je wil linken
$Links = @{
    "$HOME\.glzr\glazewm\config.yaml" = "$Dotfiles\glazewm\config.yaml"
    "$HOME\.gitconfig"               = "$Dotfiles\.gitconfig"
    "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" = "$Dotfiles\powershell\profile.ps1"
}

foreach ($Target in $Links.Keys) {
    $Source = $Links[$Target]

    if (Test-Path $Target) {
        Write-Host "Verwijder bestaande $Target"
        Remove-Item $Target -Force -Recurse
    }

    Write-Host "Link maken: $Target -> $Source"
    New-Item -ItemType SymbolicLink -Path $Target -Target $Source
}