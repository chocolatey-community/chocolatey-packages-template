$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = 'dvdflick'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://managedway.dl.sourceforge.net/project/dvdflick/dvdflick/DVD%20Flick%201.3.0.7/dvdflick_setup_1.3.0.7.exe'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'dvdflick*'
  checksum      = 'C3F95BD780C88A2B5F599A2E475A1276D9A37C24B455E91A4A6AFB214B43C03D'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
