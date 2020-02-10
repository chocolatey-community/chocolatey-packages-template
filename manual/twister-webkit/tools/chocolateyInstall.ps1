$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = 'twister-webkit'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://github.com/iShift/twister-webkit/releases/download/0.9.28.0/Twister-0.9.28.0.exe'
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'twister-webkit*'
  checksum      = '644E23776292C167C1819F1B7117146ED512C626C4B9951CE080E36383544F66'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
