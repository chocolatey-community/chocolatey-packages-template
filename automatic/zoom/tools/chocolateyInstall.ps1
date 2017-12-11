$checksum = '5e963e266aae9c23acf9680e2e0251689e2be9d89776572e2af9306143c40e57'
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
