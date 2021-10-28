$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/tonedefdev/terracreds/releases/download/v2.0.0/terracreds_2.0.0_windows_amd64.zip'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url

  checksum      = 'ee799b46cfc8c3f2aa8d364b35d0f39dc39d2c3e651fe13599816efe5847161e'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
