$checksum = '3FF5102E5A4C24C0A190DF1D17AB8B5D7E6C45CF0EFDEB4212EEA00C05E86F5C'

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
