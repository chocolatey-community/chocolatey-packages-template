$checksum = '7ca33ba41d0628860c3d0ff5e53852f987b4422f2c175d5a6187193395514378'
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
