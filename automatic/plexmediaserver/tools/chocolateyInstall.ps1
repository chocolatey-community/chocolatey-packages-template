$checksum = 'e81c738e569e701660dfd3be2f4cc3b8f741270c74699b6365ec2410ee9643ce'
$url = 'https://downloads.plex.tv/plex-media-server/1.3.4.3285-b46e0ea/Plex-Media-Server-1.3.4.3285-b46e0ea.exe'

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
