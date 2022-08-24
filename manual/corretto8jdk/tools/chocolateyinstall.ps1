$packageArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url64bit = 'https://corretto.aws/downloads/resources/8.342.07.1/amazon-corretto-8.342.07.1-windows-x64-jdk.msi'
  Checksum64 = '5a0b0f2040dd7ee97a09215f61fc83f5'
  ChecksumType64 = 'md5'
  fileType      = 'msi'
  silentArgs    = "INSTALLLEVEL=3 /quiet"
}

Install-ChocolateyPackage @packageArgs
