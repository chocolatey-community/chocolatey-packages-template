$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = 'clipcache'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://www.xrayz.co.uk/download/ccsetup.exe'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'clipcache*'
  checksum      = '424E0A11588AAAE19D5DA0BE287DDE3EB7032AB6398416CAB2974422DC2A9A04'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs