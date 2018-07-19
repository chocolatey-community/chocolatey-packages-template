$checksum = 'f43192df3eb3382824d062802ba3147b824dcb8eef063c102133bdc5269ad9b3'
$url = 'https://downloads.plex.tv/plex-media-server/1.13.4.5251-2e6e8f841/Plex-Media-Server-1.13.4.5251-2e6e8f841.exe'

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
