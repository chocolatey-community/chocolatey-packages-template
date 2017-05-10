$checksum = 'b25c3ae02d4a4c064c653d3e94457084eb12a0255ab83d182e51c61728c804c2'
$url = 'https://downloads.plex.tv/plex-media-server/1.5.6.3790-4613ce077/Plex-Media-Server-1.5.6.3790-4613ce077.exe'

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
