$checksum = '9e22e3abec73ad86701e7257e0d9ac32f6793e29fe7b664633fe994202f9da45'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.18.6.2368-97add474d/windows/PlexMediaServer-1.18.6.2368-97add474d-x86.exe'

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
