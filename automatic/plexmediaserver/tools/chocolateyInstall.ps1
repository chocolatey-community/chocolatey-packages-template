$checksum = '8b9bcb2f51944a4f320ae987fa204a8b21ea7024004577658fb38ce6df5c4a74'
$url = 'https://downloads.plex.tv/plex-media-server/1.9.1.4272-b207937f1/Plex-Media-Server-1.9.1.4272-b207937f1.exe'

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
