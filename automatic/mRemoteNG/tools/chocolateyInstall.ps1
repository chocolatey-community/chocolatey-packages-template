$checksum = 'a820d76d996e7a4077b23dbf1d9127c761acdae8e2b0f8c87508f0a3f8df8216'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.75.7010/mRemoteNG-Installer-1.75.7010.21169.msi'

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
