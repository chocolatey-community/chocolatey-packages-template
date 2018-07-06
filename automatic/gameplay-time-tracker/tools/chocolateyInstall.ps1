$checksum = '3ff5102e5a4c24c0a190df1d17ab8b5d7e6c45cf0efdeb4212eea00c05e86f5c'

$packageArgs = @{
  packageName   = 'gameplay-time-tracker'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://www.gameplay-time-tracker.info/Versions/GameplayTimeTrackerInstaller.exe'
  silentArgs    = '/verysilent /norestart /suppressmsgboxes'
  validExitCodes= @(0)
  softwareName  = 'Gameplay Time Tracker*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
