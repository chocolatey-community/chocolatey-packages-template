$checksum = '730c01c0a9890dcbfb039ef29cf400228651482e331d84b93ad452c748eb5f94'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.18.1.1973-0f4abfbcc/windows/PlexMediaServer-1.18.1.1973-0f4abfbcc-x86.exe'

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
