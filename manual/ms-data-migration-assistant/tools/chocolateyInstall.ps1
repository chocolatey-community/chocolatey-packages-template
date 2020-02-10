$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = 'ms-data-migration-assistant'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = 'https://download.microsoft.com/download/C/6/3/C63D8695-CEF2-43C3-AF0A-4989507E429B/DataMigrationAssistant.msi'
  silentArgs    = '/quiet /norestart'
  validExitCodes= @(0)
  softwareName  = 'Microsoft Data Migration Assistant*'
  checksum      = 'D1CDC9B48651F3BA5CCA2BC6E263627FDD4F1DFED070869649A3B35F5E2A70D4'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs