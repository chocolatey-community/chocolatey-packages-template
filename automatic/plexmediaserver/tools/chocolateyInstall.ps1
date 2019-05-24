$checksum = '096462d8c38855bf7afd2e410cbecfa686a19f7c11fb9d6402b95590721dd7a6'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.15.6.1079-78232c603/windows/PlexMediaServer-1.15.6.1079-78232c603-x86.exe'

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
