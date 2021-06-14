$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/tonedefdev/terracreds/releases/download/v1.1.1/terracreds_1.1.1_windows_amd64.zip'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url

  checksum      = '5e1ae8293ad8b0e858380460e12103f141def9c57f12800a03d25ab87b5f3594'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
