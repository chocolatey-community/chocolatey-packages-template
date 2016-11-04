$checksum = '029F918A29B2B311711788E8A477C8DE529C11D7DBA3CAF99CBBDE5A983EFDAD'

$packageArgs = @{
  packageName   = 'steam'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://media.steampowered.com/client/installer/SteamSetup.exe'
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'steam*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
