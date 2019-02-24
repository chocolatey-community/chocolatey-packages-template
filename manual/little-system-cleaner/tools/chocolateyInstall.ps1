$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = 'little-system-cleaner'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://pilotfiber.dl.sourceforge.net/project/little-system-cleaner/Little%20System%20Cleaner/0.3/Little_System_Cleaner_07_29_2015.exe'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'Little System Cleaner*'
  checksum      = 'F18D14600DF3E87F677E9D1FF0AA6ED553CC3C21962AEF075917B06875499121'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
