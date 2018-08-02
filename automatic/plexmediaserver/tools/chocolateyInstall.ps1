$checksum = '986222ce635e4ec1cd08b11a7713af20b691b6ffa682f72ecbb44eac048d11cb'
$url = 'https://downloads.plex.tv/plex-media-server/1.13.5.5291-6fa5e50a8/Plex-Media-Server-1.13.5.5291-6fa5e50a8.exe'

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
