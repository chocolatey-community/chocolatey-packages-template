$checksum = '02f23ccecdb1bafb91227e023ae350c6422cf17deb07b7eb381278d2c9082f96'
$url = 'https://downloads.plex.tv/plex-media-server/1.7.5.4035-313f93718/Plex-Media-Server-1.7.5.4035-313f93718.exe'

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
