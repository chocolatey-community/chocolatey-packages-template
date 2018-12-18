$checksum = '06e2c54d9da123f6859590af522e46bf2bfd58ebe62db039f874025afe467253'
$url = 'https://downloads.plex.tv/plex-media-server/1.14.1.5488-cc260c476/Plex-Media-Server-1.14.1.5488-cc260c476.exe'

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
