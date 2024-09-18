$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'qsync*'
  fileType       = 'EXE'
  url            = 'https://download.qnap.com/Storage/Utility/QNAPQsyncClientWindows-5.1.6.0906.exe'  
  checksum       = '197d1143d12db1c594575cee762ee3f10ac62dbcc8c290abb439211c21ca3cf4'
  checksumType   = 'sha256'
  silentArgs     = "/S"
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
