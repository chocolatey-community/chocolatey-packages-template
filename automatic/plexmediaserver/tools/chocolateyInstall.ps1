$checksum = '1eaf5dddb798f32fe37889c3a042b277113adfe868559105c9162be2a8290eeb'
$url = 'https://downloads.plex.tv/plex-media-server/1.5.3.3580-4b377d295/Plex-Media-Server-1.5.3.3580-4b377d295.exe'

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
