$checksum = 'f9ba80990ad2403dd8d34f31710ab56deb01c86de9a694847c4924eb2201a686'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.75/mRemoteNG-Installer-1.75.6269.29909.msi'

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
