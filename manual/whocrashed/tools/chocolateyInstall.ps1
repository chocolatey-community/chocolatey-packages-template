$ErrorActionPreference = 'Stop'

$checksum = '0A7E3A03256D3143118BE5389F0C5F7F405A40066D999E246C57280E9282AE14'
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