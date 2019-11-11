$ErrorActionPreference = 'Stop'
$checksum = '58539775D0C283C553FF09FF6304E03BCD5FAAB8FD2AC5FF7E881F661CB01D96'

$packageArgs = @{
  packageName   = 'glip'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://downloads.ringcentral.com/glip/rc/19.11.1/x64/RingCentral-19.11.1-x64.exe'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'glip*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
