$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/tonedefdev/terracreds/releases/download/v1.0.3/terracreds_1.0.3_windows_amd64.zip'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url

  checksum      = '3a7dad16b3e68b725c2ce69645b8a932b1dd0cbd28f629efa8c4ba1e125c985e'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
