$checksum = 'e57facee3a3ada8ed33d0518c3d12cbf0899daf36b9a7f99e08a448e9f1f135d'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.18.2.2029-36236cc4c/windows/PlexMediaServer-1.18.2.2029-36236cc4c-x86.exe'

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
