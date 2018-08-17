$checksum = '35063f8a960ed40e363a3ddce1b1393102a9ad86b00eea5f3f9ec0dfbd6ac96c'

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
