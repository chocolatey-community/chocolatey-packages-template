$checksum = 'ce4a4e6eff048aa0920163813749a44560f00308084d82937630be5d7bbea7eb'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.75Hotfix6/mRemoteNG-Installer-1.75.7006.16707.msi'

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
