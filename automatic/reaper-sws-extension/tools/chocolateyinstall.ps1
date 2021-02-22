$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'reaper-sws-extension*'
  fileType       = 'EXE'
  url            = 'https://www.sws-extension.org/download/featured/sws-2.12.1.3-Windows-x86.exe'
  checksum       = 'dc5e469c8c1512794259d222130940e587e88589dbf061ea661fde588fac5d16'
  checksumType   = 'sha256'
  url64          = 'https://www.sws-extension.org/download/featured/sws-2.12.1.3-Windows-x64.exe'
  checksum64     = '0b438dc7f0434552f1f333ed5c0ba1964daa48af57a2ad0de06b3192f7019412'
  checksumType64 = 'sha256'
  silentArgs     = "/S"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
