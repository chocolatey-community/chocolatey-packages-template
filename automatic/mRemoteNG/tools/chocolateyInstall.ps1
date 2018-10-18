$checksum = 'ac0e3d6fab0d93e8bc51f656d476b8dda3a5451d796d6a8659feb49f9e0d3c2b'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.76.11/mRemoteNG-Installer-1.76.11.40527.msi'

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
