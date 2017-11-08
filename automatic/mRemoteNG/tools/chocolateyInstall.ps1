$checksum = 'be65f51392daff1a73083d65342e106cb6ebeeb83c369eb51739fe9e805914d0'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.75.7011/mRemoteNG-Installer-1.75.7011.34963.msi'

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
