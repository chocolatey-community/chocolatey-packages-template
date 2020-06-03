$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName  
  url            = 'https://github.com/lucasg/Dependencies/releases/download/v1.10/Dependencies_x86_Release.zip'
  checksum       = 'C2F8F8ADC6BF4D54EC13936557C898B6BF561C53C8DCB945D0A03A68B4E4E413'
  checksumType   = 'sha256'
  url64          = 'https://github.com/lucasg/Dependencies/releases/download/v1.10/Dependencies_x64_Release.zip'
  checksum64     = '44DF956DBE267E0A705224C3B85D515FEE2ADC87509861E24FB6C6B0EA1B86D6'
  checksumType64 = 'sha256'  
}

Install-ChocolateyZipPackage @packageArgs
