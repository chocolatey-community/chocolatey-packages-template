$checksum = 'bfa60719f1d9f164f54cc09843d4e3a37134d15d23a3c14b0777cd751fd9072b'
$url = 'https://downloads.plex.tv/plex-media-server/1.13.9.5456-ecd600442/Plex-Media-Server-1.13.9.5456-ecd600442.exe'

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
