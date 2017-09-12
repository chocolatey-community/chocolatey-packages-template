$checksum = 'ac3a4406e4ad2ce59d6f02b2d01ccd541b2ca346af0d6b6a54dfd1999eabe8e8'

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
