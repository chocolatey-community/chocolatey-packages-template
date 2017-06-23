$checksum = '34a9ad61624e3ec88642ba29078d792b77cf6f2d1fe87c791d88fc883b947e79'

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
