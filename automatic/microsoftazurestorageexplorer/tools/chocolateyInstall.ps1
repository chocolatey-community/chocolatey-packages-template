$checksum = '578CEA6AC0587168D99574741E6D9BE3017E58A5F1B913065F11FB6869434C66'

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
