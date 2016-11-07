$checksum = '2d637780be5875221448dc259ce8ae8f5f9fc95adc87a2571610e305826df6a3'
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
