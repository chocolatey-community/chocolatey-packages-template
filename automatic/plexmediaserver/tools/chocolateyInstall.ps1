$checksum = 'd7676e3b37de677d24c86d7fa00139c99bbb2001fa841b0a454bfc20b80d5c9a'
$url = 'https://downloads.plex.tv/plex-media-server/1.4.4.3495-edef59192/Plex-Media-Server-1.4.4.3495-edef59192.exe'

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
