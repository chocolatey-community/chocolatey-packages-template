$packageArgs = @{
  packageName   = 'plexmediaserver'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://downloads.plex.tv/plex-media-server/1.0.3.2461-35f0caa/Plex-Media-Server-1.0.3.2461-35f0caa-en-US.exe'
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'plexmediaserver*'
  checksum      = 'B31465A25C252B4B52019077BFCEA96B5D379508CAACB045F8762712B9193A25'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs