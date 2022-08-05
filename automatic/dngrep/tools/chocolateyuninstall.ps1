$ErrorActionPreference = 'Stop'

$packageName = 'dngrep'

$installLocation = Get-AppInstallLocation "$packageName*"
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }

rm $installLocation -recurse -force
Write-Host "$packageName removed"