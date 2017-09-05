$checksum = '44826f748405d623074b9f4674c9ca9fe22ccf0cfc5d1a8b4e59c78eb93bfedf'
$url = 'https://downloads.plex.tv/plex-media-server/1.8.3.4235-2d20185b0/Plex-Media-Server-1.8.3.4235-2d20185b0.exe'

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
