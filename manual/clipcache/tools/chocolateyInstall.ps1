$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = 'clipcache'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://www.xrayz.co.uk/download/ccsetup.exe'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'clipcache*'
  checksum      = '3F67550C7F85C242A8707D7F2299D8C913654E5B8B6C111A1C5B687CEF7BD7EA'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs