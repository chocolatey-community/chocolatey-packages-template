$checksum = '40063d7120acaf31960a73c00d8aa310498c90be1f372072edf4da311ef42569'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.16.3.1402-22929c8a2/windows/PlexMediaServer-1.16.3.1402-22929c8a2-x86.exe'

Start-CheckandStop "Plex Media Server"

$packageArgs = @{
  packageName   = 'plexmediaserver'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = $url
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'plexmediaserver*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs

if ($ProcessWasRunning -eq "True") {&$ProcessFullPath}
