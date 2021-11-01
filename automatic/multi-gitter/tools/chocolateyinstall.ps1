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
  url            = 'https://github.com/lindell/multi-gitter/releases/download/v0.36.1/multi-gitter_0.36.1_Windows_i386.tar.gz'
  checksum       = 'fb3869ba3f63a1e4c93cd7bd1106478d2fe223bc972147572f4fef07454ad776'
  checksumType   = 'sha256'
  url64          = 'https://github.com/lindell/multi-gitter/releases/download/v0.36.1/multi-gitter_0.36.1_Windows_x86_64.tar.gz'
  checksum64     = '7ff956446bc24acc7114c5bc31ad6028d69b1ffe47bfc3cfa148b666fff18027'
  checksumType64 = 'sha256'  
}

# Extract .tar.gz into temporary directory
Install-ChocolateyZipPackage @packageArgs
# Extract .tar into installation directory
$File = Get-ChildItem -File -Path $tempDir -Filter *.tar
Get-ChocolateyUnzip -fileFullPath $File.FullName -destination $installDir
# Remove temporary directory
Remove-Item $tempDir -Recurse
