$ErrorActionPreference = 'Stop';

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$pp = Get-PackageParameters

$installDir = $toolsPath
if ($pp.InstallDir)
{ 
  $installDir = $pp.InstallDir
}
Write-Host "$env:ChocolateyPackageName is going to be installed in '$installDir'"

# Create temporary directory to extract .tar.gz -> .tar
$tempDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid())
New-Item -ItemType Directory -Path $tempDir

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName  
  unzipLocation  = $tempDir
  url            = 'https://github.com/lindell/multi-gitter/releases/download/v0.40.0/multi-gitter_0.40.0_Windows_i386.tar.gz'
  checksum       = '94d06d0bc08c8beac701c9c2fa6983670f8c613335e9d8de460fae6a10bcc434'
  checksumType   = 'sha256'
  url64          = 'https://github.com/lindell/multi-gitter/releases/download/v0.40.0/multi-gitter_0.40.0_Windows_x86_64.tar.gz'
  checksum64     = '7690873f25c11f9a2b40f8b1ee3d71c2e9ca1fe26ed11c3ca092c176d3ce1a6f'
  checksumType64 = 'sha256'  
}

# Extract .tar.gz into temporary directory
Install-ChocolateyZipPackage @packageArgs
# Extract .tar into installation directory
$File = Get-ChildItem -File -Path $tempDir -Filter *.tar
Get-ChocolateyUnzip -fileFullPath $File.FullName -destination $installDir
# Remove temporary directory
Remove-Item $tempDir -Recurse
