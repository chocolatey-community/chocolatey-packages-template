$checksum = '1cc6ea3e2cfa13ba6d622d1bc21dceefbe39a43be7144f608fe865e985de0934'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.76.10/mRemoteNG-Installer-1.76.10.42392.msi'

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
