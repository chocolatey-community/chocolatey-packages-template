$checksum = 'd402f512d3319746e7980b8bf2003eb6e01d37598b7f0086253989081e47400a'
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
