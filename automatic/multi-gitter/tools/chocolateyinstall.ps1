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
  url            = 'https://github.com/lindell/multi-gitter/releases/download/v0.38.2/multi-gitter_0.38.2_Windows_i386.tar.gz'
  checksum       = '24bd41f993341c75e70729d11e570e1c74858801d704baed34ae82a67fd8dac1'
  checksumType   = 'sha256'
  url64          = 'https://github.com/lindell/multi-gitter/releases/download/v0.38.2/multi-gitter_0.38.2_Windows_x86_64.tar.gz'
  checksum64     = '853f5bc8d1a98f4893fb4209d0765b1de771bfa7955b8b6a5756968ba7615e5f'
  checksumType64 = 'sha256'  
}

# Extract .tar.gz into temporary directory
Install-ChocolateyZipPackage @packageArgs
# Extract .tar into installation directory
$File = Get-ChildItem -File -Path $tempDir -Filter *.tar
Get-ChocolateyUnzip -fileFullPath $File.FullName -destination $installDir
# Remove temporary directory
Remove-Item $tempDir -Recurse
