$checksum = '7f349fbeba6676f432754d9354130af7c6d546db842496088427752cd093aac3'
$url = 'https://assets.cdngetgo.com/d7/8e/3ad5cf554afcbe07a5e89aa90ba8/g2msetup83811282-it.zip'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$zipArgs = @{
  packagename = 'gotomeeting'
  url = $url
  unzipLocation = $toolsDir
  checksum = $checksum
  checksumType = "sha256"
}

Install-ChocolateyZipPackage $zipArgs

$packageArgs = @{
  packageName   = 'gotomeeting'
  fileType      = 'msi'
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'gotomeeting*'
  checksum      = $checksum
  checksumType  = 'sha256'
  file          = $unzipLocation
}

Install-ChocolateyInstallPackage $packageArgs