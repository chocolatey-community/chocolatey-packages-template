$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/tonedefdev/terracreds/releases/download/v2.1.1/terracreds_2.1.1_windows_amd64.zip'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url

  checksum      = 'b5ca47754cf6ad21a3555d2c65c6821091e3f28677a8a5f0e0c7f8760df60869'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
