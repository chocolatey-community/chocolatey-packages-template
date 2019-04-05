$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = 'clipcache'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://www.xrayz.co.uk/download/ccsetup.exe'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'clipcache*'
  checksum      = 'DEC258AC357F1A13029DD6338187D28C88C37860E8EC54546E644909630623ED'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs