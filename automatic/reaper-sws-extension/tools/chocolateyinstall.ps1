$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'reaper-sws-extension*'
  fileType       = 'EXE'
  url            = 'https://www.sws-extension.org/download/featured/sws-2.14.0.3-Windows-x86.exe'
  checksum       = '749bb6302c5c5d80765c8f9b278cdbecbfe43fbafdd466c53bf35551027c855b'
  checksumType   = 'sha256'
  url64          = 'https://www.sws-extension.org/download/featured/sws-2.14.0.3-Windows-x64.exe'
  checksum64     = '6eed697f40bd54f90f99abd62073d0de3c332ba09a72bf8f9844b5158f346aef'
  checksumType64 = 'sha256'
  silentArgs     = "/S"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
