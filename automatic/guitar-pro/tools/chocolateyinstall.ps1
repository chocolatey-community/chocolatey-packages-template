$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'guitar-pro*'
  fileType       = 'EXE'
  url            = 'https://downloads.guitar-pro.com/gp7/stable/guitar-pro-7-setup.exe'  
  checksum       = '7F509922ECE83B94CFFB911517818170FA63EBB8D253BE483AB249C294CF614C'
  checksumType   = 'sha256'
  silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
