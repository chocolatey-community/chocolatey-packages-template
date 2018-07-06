$checksum = 'FD511FB7180A32B811D9FA7481ED78EFFF3FB82D968A2CB254BEF5989E5BDEA7'
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