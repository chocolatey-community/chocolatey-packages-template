$ErrorActionPreference = 'Stop'
$checksum = '3ef3c210c475b0f51f58d443b8c87994d7cc1459ad9e64d958946f9b2443cdfc'
$url = 'https://zoom.us/client/latest/ZoomInstallerFull.msi'

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
