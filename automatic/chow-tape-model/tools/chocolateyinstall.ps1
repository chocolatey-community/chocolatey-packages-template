$ErrorActionPreference = 'Stop';

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$pp = Get-PackageParameters

$installDir = $toolsPath
if ($pp.Vst3Dir)
{ 
  $installDir = [System.IO.Path]::Combine($pp.Vst3Dir, "ChowTapeModel")
}
Write-Host "$env:ChocolateyPackageName is going to be installed in '$installDir'"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName  
  unzipLocation  = $installDir
  url            = 'https://github.com/jatinchowdhury18/AnalogTapeModel/releases/download/v2.9.0/CHOWTapeModel-Win32-2.9.0.zip'
  checksum       = '074d07a6bdcba8f92f235a9721fb6f1e2a103e214858bd840e0430c3ac669869'
  checksumType   = 'sha256'
  url64          = 'https://github.com/jatinchowdhury18/AnalogTapeModel/releases/download/v2.9.0/CHOWTapeModel-Win64-2.9.0.zip'
  checksum64     = '41a2474d0c85f8729746def508cefc3a35b13b948ba14df2099345aa32371403'
  checksumType64 = 'sha256'  
}

Install-ChocolateyZipPackage @packageArgs
