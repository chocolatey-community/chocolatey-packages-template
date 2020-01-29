$checksum = '27d8b3af485bba476c7dae157560e8a1d9df6303de9e309de613a75b11ce2f84'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.18.5.2309-f5213a238/windows/PlexMediaServer-1.18.5.2309-f5213a238-x86.exe'

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
