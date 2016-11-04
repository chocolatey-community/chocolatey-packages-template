$checksum = '255d9fe553d074d2d726f0caada49d42121fbd44bf86b792e65a4b17e66a4213'
$url = 'https://downloads.plex.tv/plex-media-server/1.2.5.2966-3f767e7/Plex-Media-Server-1.2.5.2966-3f767e7.exe'

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
