$checksum = 'ea93f212d42f0b05b02e110629ea65fadb8a69ad24c6b7c983c410067cf12796'

$packageArgs = @{
  packageName   = 'evernote'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://evernote.com/download/get.php?file=Win'
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'evernote*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
