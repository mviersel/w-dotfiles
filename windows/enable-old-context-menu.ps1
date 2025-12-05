\
# Enable classic context menu on Windows 11
$clsidPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"

New-Item -Path $clsidPath -Force | Out-Null
New-Item -Path "$clsidPath\InprocServer32" -Force | Out-Null

Write-Host "Old context menu enabled. Restarting Explorer..."
Stop-Process -Name explorer -Force
