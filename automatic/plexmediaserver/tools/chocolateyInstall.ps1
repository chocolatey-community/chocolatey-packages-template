$checksum = 'b4ea8fbc3aa2c553efe45353d4fa60ea3cf3939d4512ba80da447d58564f4d84'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.16.2.1321-ad17d5f9e/windows/PlexMediaServer-1.16.2.1321-ad17d5f9e-x86.exe'

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
