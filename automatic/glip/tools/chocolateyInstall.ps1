$checksum = '3a8f828b849ea02c76cd75ad426170ff3673aa6041a43d55cceac8e084f8b5f2'

$packageArgs = @{
  packageName   = 'glip'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://downloads.ringcentral.com/glip/rc/GlipForWindows64'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'glip*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
