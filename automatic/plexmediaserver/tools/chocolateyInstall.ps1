$checksum = 'df73149d8d58a2c868da38c5b7b9cbeeaa0f3b83fc3ae1a8f17af036f649a2ca'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.18.0.1913-e5cc93306/windows/PlexMediaServer-1.18.0.1913-e5cc93306-x86.exe'

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
