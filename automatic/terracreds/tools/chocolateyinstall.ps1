$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/tonedefdev/terracreds/releases/download/v2.1.0/terracreds_2.1.0_windows_amd64.zip'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url

  checksum      = '2b3d6631cf3f6fbf12133badef5d98881b6ed5ee92e5138852365afb2c7505bf'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
