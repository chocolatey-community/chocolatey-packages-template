$checksum = '63d90cc61475a3dc2cb6df65206774cfcb46ef0dc6e0c57a76c8dff76d7d4645'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.15.3.858-fbfb913f7/windows/PlexMediaServer-1.15.3.858-fbfb913f7-x86.exe'

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
