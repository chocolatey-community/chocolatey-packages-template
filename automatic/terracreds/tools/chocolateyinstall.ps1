$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/tonedefdev/terracreds/releases/download/v1.1.0/terracreds_1.1.0_windows_amd64.zip'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url

  checksum      = '7649bffd18fef3aa007143cf294cace8e0c89a42a0b74ccc79349a7c8d0f5da9'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
