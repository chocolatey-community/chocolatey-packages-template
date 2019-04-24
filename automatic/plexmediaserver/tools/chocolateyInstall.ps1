$checksum = 'a4742eaa7b81b9ed0a0f943435509932668824342692497dacd76a6dfff4e6f6'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.15.4.993-bb4a2cb6c/windows/PlexMediaServer-1.15.4.993-bb4a2cb6c-x86.exe'

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
