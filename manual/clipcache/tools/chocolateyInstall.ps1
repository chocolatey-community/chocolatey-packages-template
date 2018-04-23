$packageArgs = @{
  packageName   = 'clipcache'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://www.xrayz.co.uk/download/ccsetup.exe'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'clipcache*'
  checksum      = '44A768BE767F62AD148EF99FB9D46AB29B48F84928208604EC334E8A712CBF58'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs