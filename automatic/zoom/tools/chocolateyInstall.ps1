$ErrorActionPreference = 'Stop'
$checksum = '7F8A6C9882B5069E074777912C837417521235E373F56773B92A69E0A1C429AD'
$url = 'https://zoom.us/client/4.6.13610.1201/ZoomInstallerFull.msi'

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
