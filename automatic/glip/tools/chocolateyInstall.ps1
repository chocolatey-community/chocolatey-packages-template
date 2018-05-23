$checksum = '8F00B17D20F8B02079581CF9E0A757A13124B94210FC757DC7B8254789E681E8'

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