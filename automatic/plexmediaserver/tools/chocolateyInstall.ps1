$checksum = '691c5b7fa9e1f5faa782c53774389a00ba27434ee88361c01b5ee9d3e63dccae'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.17.0.1709-982421575/windows/PlexMediaServer-1.17.0.1709-982421575-x86.exe'

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
