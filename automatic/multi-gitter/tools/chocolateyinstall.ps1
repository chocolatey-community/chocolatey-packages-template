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
  url            = 'https://github.com/lindell/multi-gitter/releases/download/v0.38.3/multi-gitter_0.38.3_Windows_i386.tar.gz'
  checksum       = '6edbce5af9be2fd1d4159f516c9c16e1c0d9ab98df47ba6862e0096bb7dc934d'
  checksumType   = 'sha256'
  url64          = 'https://github.com/lindell/multi-gitter/releases/download/v0.38.3/multi-gitter_0.38.3_Windows_x86_64.tar.gz'
  checksum64     = '9f1cd30cb2f1ef229c57b027bf6fc2edd19a4558db858b346882255fe7e5aac4'
  checksumType64 = 'sha256'  
}

# Extract .tar.gz into temporary directory
Install-ChocolateyZipPackage @packageArgs
# Extract .tar into installation directory
$File = Get-ChildItem -File -Path $tempDir -Filter *.tar
Get-ChocolateyUnzip -fileFullPath $File.FullName -destination $installDir
# Remove temporary directory
Remove-Item $tempDir -Recurse
