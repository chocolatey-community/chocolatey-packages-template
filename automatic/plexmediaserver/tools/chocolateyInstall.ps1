$checksum = 'e02a9324bacfcbabbea40463b10388c18810f652fcf824af0dad7fad5bd3329c'
$url = 'https://downloads.plex.tv/plex-media-server/1.4.3.3433-03e4cfa35/Plex-Media-Server-1.4.3.3433-03e4cfa35.exe'

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
