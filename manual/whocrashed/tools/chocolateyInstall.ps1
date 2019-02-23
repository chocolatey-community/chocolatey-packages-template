$ErrorActionPreference = 'Stop'

$checksum = '5DB0C53D82AC55BE767A2B7909A090A01FE7B885F59769894B33B88F64B28991'
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