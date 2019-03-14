$checksum = '978a8bdac62ab004ff2cef57c3bbea46d19ac9bf45d60b19326aa151064117ca'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.15.1.791-8bec0f76c/windows/PlexMediaServer-1.15.1.791-8bec0f76c-x86.exe'

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
