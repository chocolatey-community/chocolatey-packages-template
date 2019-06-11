$checksum = 'cd33dea79fc7379fc89bcc3a6743840b48f3ca5fbe926dcfc86c48406ba185d9'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.15.8.1198-eadbcbb45/windows/PlexMediaServer-1.15.8.1198-eadbcbb45-x86.exe'

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
