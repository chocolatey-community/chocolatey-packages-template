$checksum = 'b6d519ff298e4846ba3f3ba5a485c7e1759333f3deff33024c25897fa4592cd3'
$url = 'https://downloads.plex.tv/plex-media-server/1.8.4.4249-3497d6779/Plex-Media-Server-1.8.4.4249-3497d6779.exe'

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
