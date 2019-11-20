$checksum = '76aab99012afc1e8d5eeac6123dffb486e5ffd3d0c79e61f233fed63e2239256'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.18.2.2041-3d469cb32/windows/PlexMediaServer-1.18.2.2041-3d469cb32-x86.exe'

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
