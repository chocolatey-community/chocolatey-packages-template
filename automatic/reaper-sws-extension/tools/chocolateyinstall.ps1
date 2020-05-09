$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  url           = 'http://www.sws-extension.org/download/featured/sws-v2.10.0.1-x64-install.exe'
  softwareName  = 'reaper-sws-extension*'
  checksum      = '939F466AA0822BBA778A44BA2414154D2B4B0CB1F56EE55254D5D02976DFBFDC'
  checksumType  = 'sha256'
  silentArgs    = "/S"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
