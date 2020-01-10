$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = 'stickies'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://www.zhornsoftware.co.uk/stickies/stickies_setup_10_0a.exe'
  silentArgs    = '-silent'
  validExitCodes= @(0)
  softwareName  = 'stickies*'
  checksum      = '6F17C14C63FC269F28E5C374F6BA55F4AF1274D9684BA58F70E62DBB9BE6D1FD'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
