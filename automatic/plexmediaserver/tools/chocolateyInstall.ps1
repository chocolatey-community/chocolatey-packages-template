$checksum = 'df3f7c8b0cfdf84e43080eddd54a4080d962ef4121a366729909ea11b10da280'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.18.2.2058-e67a4e892/windows/PlexMediaServer-1.18.2.2058-e67a4e892-x86.exe'

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
