$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'guitar-pro*'
  fileType       = 'EXE'
  url            = 'https://downloads.guitar-pro.com/gp7/stable/guitar-pro-7-setup.exe'  
  checksum       = 'c3e508e53760633fa1cf17bdeb30d037bd7ea16c79bce3892cd33c74740c61c6'
  checksumType   = 'sha256'
  silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
