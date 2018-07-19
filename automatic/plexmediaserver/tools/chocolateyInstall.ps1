$checksum = '9000e652b35215eceb89c1a5f6942baf7189f2896058061c2be2046eca4fe86f'
$url = 'https://downloads.plex.tv/plex-media-server/1.13.4.5271-200287a06/Plex-Media-Server-1.13.4.5271-200287a06.exe'

Start-CheckandStop "Plex Media Server"

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

if ($ProcessWasRunning -eq "True") {&$ProcessFullPath}
