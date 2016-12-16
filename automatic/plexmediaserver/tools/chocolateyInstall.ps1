$checksum = '9e55ab5e25304117c479a42cb7262ac30bb023e1e3577f46ccf6efaed5eace7d'
$url = 'https://downloads.plex.tv/plex-media-server/1.3.3.3148-b38628e/Plex-Media-Server-1.3.3.3148-b38628e.exe'

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
