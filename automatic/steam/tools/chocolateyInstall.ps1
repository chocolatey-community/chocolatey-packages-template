$checksum = '3BC6942FE09F10ED3447BCCDCF4A70ED369366FEF6B2C7F43B541F1A3C5D1C51'

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
