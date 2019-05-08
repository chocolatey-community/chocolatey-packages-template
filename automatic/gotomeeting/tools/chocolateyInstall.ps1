$ErrorActionPreference = 'Stop'

$checksum = '10ace09684f9a3dc58572a25abb41ab2a69791f30787938acd56aa3b0d1c26ee'
$url = 'https://assets.cdngetgo.com/13/84/bdc590684a73a88cca4d2914c87b/g2msetup84112127-it.zip'
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
