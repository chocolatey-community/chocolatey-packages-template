$ErrorActionPreference = 'Stop'

$checksum = 'c4874077ecd97636b52be9485bd02819fcca1c889a9e161b697c9b55d390cf6c'
$url = 'https://builds.cdn.getgo.com/builds/g2m/15939/G2MSetup10.4.15939_IT.msi?c_prod=g2mwt&c_cmp=care'
$unzipLocation = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$zipArgs = @{
  packagename = 'gotomeeting'
  url = $url
  unzipLocation = $unzipLocation 
  checksum = $checksum
  checksumType = "sha256"
}

Install-ChocolateyZipPackage @zipArgs

$msiFileList = Get-ChildItem -Path $unzipLocation -Filter '*.msi'

$packageArgs = @{
  packageName   = 'gotomeeting'
  fileType      = 'msi'
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'gotomeeting*'
  file          = $msiFileList[0].FullName
}

Install-ChocolateyInstallPackage @packageArgs
