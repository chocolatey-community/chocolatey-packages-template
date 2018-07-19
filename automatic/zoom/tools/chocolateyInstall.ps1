$checksum = '8E473292137917EFACED618A00E3021F45122E1EC349C479C0A416FC8E9E0545'
$url = 'https://zoom.us/client/latest/ZoomInstallerFull.msi'

$packageArgs = @{
  packageName   = 'zoom'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = $url
  silentArgs    = '/quiet /norestart'
  validExitCodes= @(0)
  softwareName  = 'zoom*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
