$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'guitar-pro*'
  fileType       = 'EXE'
  url            = 'https://downloads.guitar-pro.com/gp7/stable/guitar-pro-7-setup.exe'  
  checksum       = '82aef7af9b8484217cdc9989c26df557a4c806d41207939f4ef141bf710970cf'
  checksumType   = 'sha256'
  silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
