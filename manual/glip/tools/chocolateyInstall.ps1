$packageArgs = @{
  packageName   = 'glip'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://downloads.ringcentral.com/glip/rc/18.01.1/x64/Glip-18.01.1-x64.exe'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'glip*'
  checksum      = '8F00B17D20F8B02079581CF9E0A757A13124B94210FC757DC7B8254789E681E8'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs