$checksum = '5b327bceb78012252fdd3ba9379b924802e4135cb9dd1585bd9a4c1e05fc717a'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.16.5.1554-1e5ff713d/windows/PlexMediaServer-1.16.5.1554-1e5ff713d-x86.exe'

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
