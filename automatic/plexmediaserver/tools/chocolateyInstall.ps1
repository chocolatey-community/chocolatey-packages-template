$checksum = 'd70fe566ba384120e50524f7b6acb3871304d1d5efab17d3eba6d75776b30573'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.16.2.1297-4b7ace214/windows/PlexMediaServer-1.16.2.1297-4b7ace214-x86.exe'

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
