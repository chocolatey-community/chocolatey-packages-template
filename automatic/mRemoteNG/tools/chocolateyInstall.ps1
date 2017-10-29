$checksum = '2b885f8da25a26e0ae1a8cf7f6f6923bc0a7b8defe3e496df96d941d9a6a7188'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.75.7009/mRemoteNG-Installer-1.75.7009.27794.msi'

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
