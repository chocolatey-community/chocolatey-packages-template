$checksum = '97048db83d4ad185e35cff0f4fef1bd9497bf9ae8d14d7408128958f1ed51fef'
$url = 'https://downloads.plex.tv/plex-media-server/1.13.5.5332-21ab172de/Plex-Media-Server-1.13.5.5332-21ab172de.exe'

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
