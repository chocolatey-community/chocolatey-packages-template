$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = 'CMSupportCenter'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = 'https://download.microsoft.com/download/6/5/2/652E5960-99D5-4B79-9939-BF7D9BFBD673/cmsupportcenter.msi'
  silentArgs    = '/quiet /norestart'
  validExitCodes= @(0)
  softwareName  = 'Configuration Manager Support Center*'
  checksum      = 'E6365825B7629C2CD588EE05A39B4FC692C05A33369FCB74FB50B7788B7E543C'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs