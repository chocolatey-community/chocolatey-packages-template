$checksum = '86363f511785ce56acdb4440fa990de5c992fe40c55dcf0fc43fad03476c5011'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.75.7012/mRemoteNG-Installer-1.75.7012.16814.msi'

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
