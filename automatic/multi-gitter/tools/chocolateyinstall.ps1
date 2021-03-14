$ErrorActionPreference = 'Stop';

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$pp = Get-PackageParameters

$installDir = $toolsPath
if ($pp.InstallDir)
{ 
  $installDir = $pp.InstallDir
}
Write-Host "$env:ChocolateyPackageName is going to be installed in '$installDir'"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName  
  unzipLocation  = $installDir
  url            = 'https://github.com/lindell/multi-gitter/releases/download/v0.36.0/multi-gitter_0.36.0_Windows_i386.tar.gz'
  checksum       = 'CEAED3CAA8729ECB8ABD0BD487A21FCA078DEFA5254A1F8549A54E793EBCAD64'
  checksumType   = 'sha256'
  url64          = 'https://github.com/lindell/multi-gitter/releases/download/v0.36.0/multi-gitter_0.36.0_Windows_x86_64.tar.gz'
  checksum64     = '4025BDB75A47BF8EC5632AAD65FD20C1FA64ED762F56FB7BE91B9026CCC0D733'
  checksumType64 = 'sha256'  
}

Install-ChocolateyZipPackage @packageArgs
