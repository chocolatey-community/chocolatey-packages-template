$checksum = '6473d79a3c2aa9428e7691780a5c82bdadb24ec397d6dc6467f1b76a6372d4ff'

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
