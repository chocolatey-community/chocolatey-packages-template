$checksum = '9aaca6033df69c3410670c1be7e3819b256261e306b752803570f9923defd5f7'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.18.3.2156-349e9837e/windows/PlexMediaServer-1.18.3.2156-349e9837e-x86.exe'

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
