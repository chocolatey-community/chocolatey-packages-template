$checksum = 'd03ba6cccaf4f6d21ffaade8f62c39111187af137e106f734e9885f99398a6b4'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.16.6.1592-b9d49bdb7/windows/PlexMediaServer-1.16.6.1592-b9d49bdb7-x86.exe'

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
