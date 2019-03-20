$checksum = '244e6d5e81ccd3a1fbde999d2ee4cc634cfbe881099632694a13734e1239d6ac'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.76.18/mRemoteNG-Installer-1.76.18.26260.msi'

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
