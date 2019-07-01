$checksum = 'c63b9b638948f9a4738b2e1880c364abd3ac624774164ec176f9b74e2576ecd3'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.16.1.1291-158e5b199/windows/PlexMediaServer-1.16.1.1291-158e5b199-x86.exe'

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
