$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'qsync*'
  fileType       = 'EXE'
  url            = 'https://download.qnap.com/Storage/Utility/QNAPQsyncClientWindows-4.5.0.0904.exe'  
  checksum       = '3a408b6bbba293a8726c92059a1f1a8081d3e0f895a49ebcc1a765b1a6d6758e'
  checksumType   = 'sha256'
  silentArgs     = "/S"
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
