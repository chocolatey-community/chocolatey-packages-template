$ErrorActionPreference = 'Stop'
$checksum = '7c779cd6bc1b210f322b93c05be2a0c9f417e147bef414244cb56b74e3206617'
$checksum64 = '6e463e242176dac41d0966396750a4aeffdcda145824b4b3d141b570a9241b0d'

$url = 'https://cdn.zoom.us/prod/5.11.4.7185/ZoomInstallerFull.msi'
$url64 = 'https://cdn.zoom.us/prod/5.11.4.7185/x64/ZoomInstallerFull.msi'

$packageArgs = @{
  packageName    = 'zoom-client'
  unzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType       = 'msi'
  url            = $url
  url64          = $url64
  silentArgs     = '/quiet /norestart ZoomAutoUpdate=True'
  validExitCodes = @(0)
  softwareName   = 'zoom*'
  checksum       = $checksum
  checksum64     = $checksum64
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
}

Install-ChocolateyPackage @packageArgs