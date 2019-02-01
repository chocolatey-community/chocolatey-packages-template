$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = 'ms-data-migration-assistant'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = 'https://download.microsoft.com/download/C/6/3/C63D8695-CEF2-43C3-AF0A-4989507E429B/DataMigrationAssistant.msi'
  silentArgs    = '/quiet /norestart'
  validExitCodes= @(0)
  softwareName  = 'Microsoft Data Migration Assistant*'
  checksum      = 'CC88BB2FB08C7AE020897DDE33F49E0A0C2EAC9C2FA8DF4E8A8AADDE88E46A79'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs