$checksum = '56f80a31efb27510eec1711ee0270b7d84ce07aaf619921b51b3364aa31416cb'
$url = 'https://downloads.plex.tv/plex-media-server/1.3.2.3112-1751929/Plex-Media-Server-1.3.2.3112-1751929.exe'

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
