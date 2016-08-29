$packageArgs = @{
  packageName   = 'microsoftazurestorageexplorer'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://download.microsoft.com/download/A/E/3/AE32C485-B62B-4437-92F7-8B6B2C48CB40/StorageExplorer.exe'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'microsoftazurestorageexplorer*'
  checksum      = '14AB9B659DBB14D88759B0F9CD39926FFF0D21E778014D1EB22FAA7C0EEAACB1'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs