$ErrorActionPreference = 'Stop'
$checksum = '01416D710FB7E6A6C483C06CB7BBADD60108A7E78248AC9C6B3C1FEC9BEDEEA6'
$url = 'https://zoom.us/client/4.5.5699.1027/ZoomInstallerFull.msi'

$packageArgs = @{
  packageName   = 'zoom'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = $url
  silentArgs    = '/quiet /norestart'
  validExitCodes= @(0)
  softwareName  = 'zoom*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
