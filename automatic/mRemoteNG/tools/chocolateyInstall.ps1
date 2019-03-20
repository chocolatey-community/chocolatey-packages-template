$checksum = '26f37a5a738ab74d90e23b097663d986507f90885586627be24604ee224a7ab5'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.76.17/mRemoteNG-Installer-1.76.17.22662.msi'

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
