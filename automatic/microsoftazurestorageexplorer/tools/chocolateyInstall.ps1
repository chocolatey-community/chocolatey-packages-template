$checksum = 'D2E470A973A445E13BF4A55976890D1CBA3BA5B2DD6ECD8439767AFF1E8544FA'

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
