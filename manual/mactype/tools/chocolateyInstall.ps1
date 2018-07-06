$checksum = 'DF5E528205E9B293993371A4F347148E42B85C5F0472A8ED5930B9E84C4A6619'
$url = 'http://www.mactype.net/station/Release/MacTypeInstaller_2017_0628_0.exe'

$packageArgs = @{
  packageName   = 'mactype'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = $url
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'MacType*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs