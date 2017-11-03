$ErrorActionPreference = 'Stop';

$packageName   = 'Depressurizer'
$unzipLocation = Join-Path "C:" $packageName
$zipFileName   = "depressurizer-$env:chocolateyPackageVersion.zip"

$packageArgs = @{
  packageName   = $packageName
  zipFileName   = $zipFileName
}

Uninstall-ChocolateyZipPackage @packageArgs
Remove-Item -Recurse -Force $unzipLocation

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutFile = Join-Path $desktop "$packageName.lnk"
if (Test-Path $shortcutFile){
    Remove-Item $shortcutFile
}
