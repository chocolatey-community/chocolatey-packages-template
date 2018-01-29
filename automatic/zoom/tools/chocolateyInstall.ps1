$checksum = '6654d08fdeff4d41eca403f998ca1f719a375156eccc3c0db0319060282b597a'
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
