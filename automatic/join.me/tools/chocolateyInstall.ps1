$url = 'https://www.join.me/Download.aspx?installer=win'
$checksum = '14AB9B659DBB14D88759B0F9CD39926FFF0D21E778014D1EB22FAA7C0EEAACB1'

$packageArgs = @{
  packageName   = 'join.me'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = 'https://download.microsoft.com/download/A/E/3/AE32C485-B62B-4437-92F7-8B6B2C48CB40/StorageExplorer.exe'
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'join.me*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs