$checksum = 'e3aae87b049dec2bab3826e76f3b315989cbd164dd70649966803ddfba7418ce'
$url = 'https://downloads.plex.tv/plex-media-server/1.5.5.3634-995f1dead/Plex-Media-Server-1.5.5.3634-995f1dead.exe'

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
