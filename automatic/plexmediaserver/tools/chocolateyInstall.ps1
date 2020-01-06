$checksum = 'c2541685ef56508cd133e34b9d7c5e8c38f49924619c470f5f611c5d260d57a0'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.18.4.2171-ac2afe5f8/windows/PlexMediaServer-1.18.4.2171-ac2afe5f8-x86.exe'

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
