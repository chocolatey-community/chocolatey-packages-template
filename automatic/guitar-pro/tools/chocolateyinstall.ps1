$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'guitar-pro*'
  fileType       = 'EXE'
  url            = 'https://downloads.guitar-pro.com/gp7/stable/guitar-pro-7-setup.exe'  
  checksum       = 'ced440b5883cd2fceed7d3d7f1c88ed657e28664f2935079f56d9fb9a1cd4ba5'
  checksumType   = 'sha256'
  silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
