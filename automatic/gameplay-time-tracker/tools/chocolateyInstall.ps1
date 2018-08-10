$checksum = '360dc830cf59bd19afa64605b8e2fd0ef05bc43817d504f8078d06d43606fe2f'

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
