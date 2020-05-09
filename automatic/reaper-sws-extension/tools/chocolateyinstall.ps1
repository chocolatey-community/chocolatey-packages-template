$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'reaper-sws-extension*'
  fileType       = 'EXE'
  url            = 'https://www.sws-extension.org/download/featured/sws-v2.10.0.1-install.exe'
  checksum       = '775ccbd19e00bcf0e904fc44e1aa7fc40e10519ca4ebd7864e9631328dd71df5'
  checksumType   = 'sha256'
  url64          = 'https://www.sws-extension.org/download/featured/sws-v2.10.0.1-x64-install.exe'
  checksum64     = '939f466aa0822bba778a44ba2414154d2b4b0cb1f56ee55254d5d02976dfbfdc'
  checksumType64 = 'sha256'
  silentArgs     = "/S"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
