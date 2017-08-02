$checksum = 'd909f785b407cbd57ed2b04ab8e95d6f993d54432a1303f6792f4e296da11b31'

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
