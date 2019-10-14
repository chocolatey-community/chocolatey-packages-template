$checksum = '8d622d88d21a0257f9f9e9118f23fad54cff9a3c66f253e08991a6bacf4ad5b7'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.18.0.1944-f2cae8d6b/windows/PlexMediaServer-1.18.0.1944-f2cae8d6b-x86.exe'

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
