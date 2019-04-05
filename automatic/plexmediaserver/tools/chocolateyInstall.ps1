$checksum = 'a1334c6c296888694bdf12fdac04e544e2a0b5769eef195f79f444ffe33b3b9c'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.15.3.876-ad6e39743/windows/PlexMediaServer-1.15.3.876-ad6e39743-x86.exe'

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
