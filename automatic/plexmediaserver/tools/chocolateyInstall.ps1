$checksum = 'ef6b361dc063e3da83cfc6f4f6f981b0d44662facedaa71a675b5aa44f54d664'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.17.0.1841-d42cfa161/windows/PlexMediaServer-1.17.0.1841-d42cfa161-x86.exe'

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
