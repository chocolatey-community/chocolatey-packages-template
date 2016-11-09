$checksum = '20e5c46a9a11fe46450a1b1200d555abd824ed66e9c860a278bdfbf74cb69192'
$url = 'https://downloads.plex.tv/plex-media-server/1.2.7.2987-1bef33a/Plex-Media-Server-1.2.7.2987-1bef33a.exe'

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
