$ErrorActionPreference = 'Stop';

$packageName   = 'depressurizer'
$unzipLocation = Join-Path "C:" $packageName

$packageArgs = @{
  packageName   = '$packageName'
  unzipLocation = $unzipLocation
  url           = 'https://github.com/Depressurizer/Depressurizer/releases/download/v0.7.4.1/depressurizer-0.7.4.1.zip'

  softwareName  = 'Depressurizer*'

  checksum      = '34be10c07c1dc0377869cf419e168ae67c5f0789d91809ba411ce8c247985b83'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutFile = Join-Path $desktop "$packageName.lnk"
$exeFile = Join-Path $unzipLocation "$packageName.exe"
Install-ChocolateyShortcut -shortcutFilePath $shortcutFile -targetPath $exeFile
