$ErrorActionPreference = 'Stop';

$packageName   = 'depressurizer'
$unzipLocation = Join-Path "C:" $packageName

$packageArgs = @{
  packageName   = '$packageName'
  unzipLocation = $unzipLocation
  url           = 'https://github.com/Depressurizer/Depressurizer/releases/download/v0.7.4.2/depressurizer-0.7.4.2.zip'

  softwareName  = 'Depressurizer*'

  checksum      = '24410ee4fd4a39c33629cb51033e266ec2db264748e13660897cfbc71592acaa'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutFile = Join-Path $desktop "$packageName.lnk"
$exeFile = Join-Path $unzipLocation "$packageName.exe"
Install-ChocolateyShortcut -shortcutFilePath $shortcutFile -targetPath $exeFile
