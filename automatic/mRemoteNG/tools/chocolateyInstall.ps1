$checksum = '1f8b8e59bbbf15fc65caeaa7e3b02b39ea574e075a8e54f76101d2b2153e54b2'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.76.19/mRemoteNG-Installer-1.76.19.35762.msi'

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
