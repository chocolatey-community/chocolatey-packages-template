$checksum = 'f722825fef7cd4d0cf81ecd4dcee4a79ae1e540ea6b02fa38d4852dd69a63449'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.16.4.1469-6d5612c2f/windows/PlexMediaServer-1.16.4.1469-6d5612c2f-x86.exe'

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
