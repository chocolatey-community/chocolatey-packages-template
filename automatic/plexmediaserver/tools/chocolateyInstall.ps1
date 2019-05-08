$checksum = '415496f54b873623a6d8ff2c692d48c1bfeb8dd15578ec45b94a24c95ffa3c10'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.15.4.994-107756f7e/windows/PlexMediaServer-1.15.4.994-107756f7e-x86.exe'

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
