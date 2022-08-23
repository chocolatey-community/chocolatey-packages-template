$ErrorActionPreference = 'Stop'

$checksum = '4188e7735eabcc313c7f56111bd13e8b524ba0ab872d6042de69e08657cec3b9'
$url = 'https://builds.cdn.getgo.com/builds/g2m/19950/G2MSetup10.19.19950_IT.msi?c_prod=g2mwt&c_cmp=care?c_prod=g2mwt&c_cmp=care'

$packageArgs = @{
  packageName    = 'gotomeeting'
  unzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType       = 'msi'
  url            = $url
  silentArgs     = '/quiet'
  validExitCodes = @(0)
  softwareName   = 'gotomeeting*'
  checksum       = $checksum
  checksumType   = 'sha256'
}

Install-ChocolateyPackage @packageArgs