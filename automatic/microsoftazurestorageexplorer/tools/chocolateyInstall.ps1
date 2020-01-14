$ErrorActionPreference = 'Stop'
$checksum = '7e2ba2cd1845751b854bffcdeb44de200d7f023c70d64e172202859e191da1ac'

$packageArgs = @{
  packageName   = 'microsoftazurestorageexplorer'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://download.microsoft.com/download/A/E/3/AE32C485-B62B-4437-92F7-8B6B2C48CB40/StorageExplorer.exe'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'microsoftazurestorageexplorer*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
