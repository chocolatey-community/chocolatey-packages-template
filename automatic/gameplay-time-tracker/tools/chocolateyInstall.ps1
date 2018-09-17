$checksum = '4d41607fef219e4edb23bddf2ff15312cf20ef158eb0ccd0ca7a1314c42dd579'

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
