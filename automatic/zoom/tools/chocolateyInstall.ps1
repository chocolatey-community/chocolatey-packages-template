$checksum = '36e39c662b629eb6b1591c57ee54ff271653285517209f413f764ffe0a7b273a'
$url = 'https://zoom.us/client/latest/ZoomInstallerFull.msi'

$packageArgs = @{
  packageName   = 'zoom'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = $url
  silentArgs    = '/quiet /norestart'
  validExitCodes= @(0)
  softwareName  = 'zoom*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
