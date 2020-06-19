$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'qsync*'
  fileType       = 'EXE'
  url            = 'https://download.qnap.com/Storage/Utility/QNAPQsyncClientWindows-4.4.0.0617.exe'  
  checksum       = '67eac78a571f0e13f38e239dcc1e9a583bebd0bf1c68b910e1156d6abfc04c0f'
  checksumType   = 'sha256'
  silentArgs     = "/S"
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
