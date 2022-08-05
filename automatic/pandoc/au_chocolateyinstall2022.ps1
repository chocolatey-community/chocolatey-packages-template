$ErrorActionPreference = 'Stop';

$url = 'https://github.com/jgm/pandoc/releases'
$checksum = 'abc'
$checksumType = 'sha256'

$pp = Get-PackageParameters

$packageName = 'pandoc'
$binRoot = if ($pp.installLocation) { $pp.installLocation } else { Get-ToolsLocation }
$installDir = Join-Path $binRoot "$packageName"
$installDirBin = "$($installDir)\current\bin"
Write-Host "Adding `'$installDirBin`' to the path and the current shell path"
Install-ChocolateyPath "$installDirBin"
$env:Path = "$($env:Path);$($installDirBin)"
$port = if ($pp.Port) { $pp.Port } else { 3306 }
$serviceName = if ($pp.serviceName) { $pp.serviceName } else { "pandoc" }
$dataDir = if ($pp.dataLocation) { Join-Path $pp.dataLocation "$packageName" } else { "update" }

if (![System.IO.Directory]::Exists($installDir)) { [System.IO.Directory]::CreateDirectory($installDir) | Out-Null }

$packageArgs = @{
  packageName    = '$env:ChocolateyPackageName'
  unzipLocation  = $installDir
  url64          = $url
  checksum64     = $checksum
  checksumType64 = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

