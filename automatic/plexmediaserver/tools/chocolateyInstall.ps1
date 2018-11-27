$checksum = '5ce06fb185ff15032075c83af1cdfe6c24df94170a3561378ee0c8266696b231'
$url = 'https://downloads.plex.tv/plex-media-server/1.14.0.5470-9d51fdfaa/Plex-Media-Server-1.14.0.5470-9d51fdfaa.exe'

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
