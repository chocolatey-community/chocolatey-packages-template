$checksum = 'b4726b82426dd36c3465638f751236bd1eaa44a384c49fae94aac324a72f037f'
$url = 'https://downloads.plex.tv/plex-media-server/1.8.1.4139-c789b3fbb/Plex-Media-Server-1.8.1.4139-c789b3fbb.exe'

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
