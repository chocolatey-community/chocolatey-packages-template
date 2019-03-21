$checksum = 'ca93ef18040d05e5b1e8a2197151dd524738e11e3fcaba04d0d3892b8a6177d1'
$url = 'https://downloads.plex.tv/plex-media-server-new/1.15.2.793-782228f99/windows/PlexMediaServer-1.15.2.793-782228f99-x86.exe'

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
