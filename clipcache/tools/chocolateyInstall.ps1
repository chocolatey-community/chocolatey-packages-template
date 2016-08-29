$packageArgs = @{
  packageName   = 'clipcache'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://www.xrayz.co.uk/download/ccsetup.exe'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'clipcache*'
  checksum      = '5EFC6ECB6B79DBA6AA3E4AF0FE9DA67098DE436CD1A96DD10DB733F5BB47B471'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs