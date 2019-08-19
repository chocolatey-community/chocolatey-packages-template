$checksum = 'a9153e13b7a132541b57b383ba26071bef682c78cd9bd593bf0cb86e4b072c23'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.16.5.1488-deeb86e7f/windows/PlexMediaServer-1.16.5.1488-deeb86e7f-x86.exe'

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
