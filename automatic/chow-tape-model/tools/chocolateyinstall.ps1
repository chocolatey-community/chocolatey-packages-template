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
  url            = 'https://github.com/jatinchowdhury18/AnalogTapeModel/releases/download/v2.7.0/ChowTape-Win32-2.7.0.zip'
  checksum       = '1F2D9BFA91D3BE4B3E1F5CEC7425A720F58BE1AE7A16FC3056071A037977B778'
  checksumType   = 'sha256'
  url64          = 'https://github.com/jatinchowdhury18/AnalogTapeModel/releases/download/v2.7.0/ChowTape-Win64-2.7.0.zip'
  checksum64     = '5E1753E971D8A834E0E7C345EDD41FC63F86EAF940376D7650D3D900D3C9F1BE'
  checksumType64 = 'sha256'  
}

Install-ChocolateyZipPackage @packageArgs
