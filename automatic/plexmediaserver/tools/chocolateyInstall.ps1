$checksum = '449139a1e91a8f71ebcb3c397c1d53778ec6ccf4e94203eb55fe5769a5472e60'
$url = 'https://downloads.plex.tv/plex-media-server/1.9.2.4285-9f65b88ae/Plex-Media-Server-1.9.2.4285-9f65b88ae.exe'

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
