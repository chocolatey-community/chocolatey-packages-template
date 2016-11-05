$checksum = 'b7554ac71b11b32f734ac9434ea03636c2eb471dd033a629725570552e973f1d'
$url = 'https://downloads.plex.tv/plex-media-server/1.2.6.2975-9394c87/Plex-Media-Server-1.2.6.2975-9394c87.exe'

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
