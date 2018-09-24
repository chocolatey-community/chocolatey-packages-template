$checksum = '207f9e2fc4be859adf7c244a3a473c7d9db1ef0f503a8cb8e0af8faba76bd2cc'
$url = 'https://downloads.plex.tv/plex-media-server/1.13.8.5395-10d48da0d/Plex-Media-Server-1.13.8.5395-10d48da0d.exe'

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
