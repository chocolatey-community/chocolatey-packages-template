$url = 'https://downloads.plex.tv/plex-media-server/1.0.3.2461-35f0caa/Plex-Media-Server-1.0.3.2461-35f0caa-en-US.exe'
$checksum = 'B31465A25C252B4B52019077BFCEA96B5D379508CAACB045F8762712B9193A25'

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