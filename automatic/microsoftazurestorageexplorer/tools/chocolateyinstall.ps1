$ErrorActionPreference = 'Stop'
$checksum = 'b7756c1d28dfd391e903d10119811a2998d2c70e3f503023e8702f3d241bde9a'
$url = 'https://github.com/microsoft/AzureStorageExplorer/releases/download/v1.25.1/Windows_StorageExplorer.exe'

$packageArgs = @{
  packageName    = 'microsoftazurestorageexplorer'
  unzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType       = 'exe'
  url            = $url
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /ALLUSERS'
  validExitCodes = @(0)
  softwareName   = 'microsoftazurestorageexplorer*'
  checksum       = $checksum
  checksumType   = 'sha256'
}

Install-ChocolateyPackage @packageArgs
