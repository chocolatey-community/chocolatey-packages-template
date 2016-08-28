$ErrorActionPreference = 'Stop'

$packageName = 'html-tidy'
$url32       = 'https://github.com/htacg/tidy-html5/releases/download/5.2.0/tidy-5.2.0-win32.zip'
$url64       = 'https://github.com/htacg/tidy-html5/releases/download/5.2.0/tidy-5.2.0-win64.zip'
$checksum32  = '94D653498B4F93B14F12A55CA06154E19C540C9B276E5D163F1CF84FA078F97A'
$checksum64  = 'DD9FD814CC44BC2FFA9B9E547B1A6CBB42B6BE7B9358542D3EE7F6E10B676423'

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  url64Bit       = $url64
  checksum       = $checksum32
  checksum64     = $checksum64
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs
