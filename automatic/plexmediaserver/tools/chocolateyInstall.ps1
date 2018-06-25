$checksum = '8a11f4dedee9adc17ee90a459b38141fa4a90b3843fe700c04b155ccbf74c110'
$url = 'https://downloads.plex.tv/plex-media-server/1.13.2.5154-fd05be322/Plex-Media-Server-1.13.2.5154-fd05be322.exe'

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