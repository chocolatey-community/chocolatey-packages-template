$ErrorActionPreference = 'Stop'

$checksum = '1FF0D2CF45526CB69872C08412C166A7252241CEBD412F1913279AA3AFDD4047'
$url = 'http://www.resplendence.com/download/whocrashedSetup.exe'

$packageArgs = @{
  packageName   = 'whocrashed'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = $url
  silentArgs    = '/VERYSILENT /NORESTART'
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'WhoCrashed*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs