$checksum = 'bc1ee51b2831db962c8ff168048880faf0f5623139bd19222026ac5e7402de06'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.76.16/mRemoteNG-Installer-1.76.16.41771.msi'

$packageArgs = @{
  packageName   = 'mremoteng'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = $url
  silentArgs    = '/quiet /norestart'
  validExitCodes= @(0)
  softwareName  = 'mremoteng*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
