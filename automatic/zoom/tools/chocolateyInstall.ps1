$checksum = 'f372579e5da4eee4fdfe05fa810c8ef03fd7d36bb9b95751be8116fb219a7f8f'
$url = 'https://zoom.us/client/latest/ZoomInstaller.exe'

$packageArgs = @{
  packageName   = 'zoom'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = $url
  silentArgs    = '/Q'
  validExitCodes= @(0)
  softwareName  = 'zoom*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
