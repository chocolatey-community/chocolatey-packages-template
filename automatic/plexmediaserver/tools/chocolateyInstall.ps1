$checksum = 'ca00cebcddf9e90b8f9b7e47810fce1d7f81f49b2147b45d0e43d899ef96203d'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.18.1.2019-c186313fe/windows/PlexMediaServer-1.18.1.2019-c186313fe-x86.exe'

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
