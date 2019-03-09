$checksum = '4457b7d29c10b6b6fbea4e0462060ce013131e66e7c3473ea53c28253510bca0'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.76.15/mRemoteNG-Installer-1.76.15.31277.msi'

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
