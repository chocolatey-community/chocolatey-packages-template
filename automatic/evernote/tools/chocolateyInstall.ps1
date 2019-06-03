$ErrorActionPreference = 'Stop'
$checksum = 'A04B00156CA9099845BDB16595E88D6E7E1EC36A4171E4BF4E0B958D7D7C65F4'

$packageArgs = @{
  packageName   = 'evernote'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://evernote.com/download/get.php?file=Win'
  silentArgs    = '/quiet'
  validExitCodes= @(0, -1073741819)
  softwareName  = 'evernote*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
