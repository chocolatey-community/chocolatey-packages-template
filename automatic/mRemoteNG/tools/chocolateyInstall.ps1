$checksum = 'b9cad935be8613aa02c5251d32b05433a2dadf2284d03eb4afa8ca4f81e9036c'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.74/mRemoteNG-Installer-1.74.6023.15437.msi'

$packageArgs = @{
  packageName   = 'mremoteng'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = $url
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'mremoteng*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
