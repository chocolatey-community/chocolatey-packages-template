$ErrorActionPreference = 'Stop';

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$pp = Get-PackageParameters

$installDir = $toolsPath
if ($pp.InstallDir)
{ 
  $installDir = $pp.InstallDir
}
Write-Host "$env:ChocolateyPackageName is going to be installed in '$installDir'"

$exeName64 = "RTL_Utility_0_5_1_x64.exe"
$exeName32 = "RTL_Utility_0_5_1_Win32.exe"
if ((Get-ProcessorBits -ge 64) -and
    ([String]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable("chocolateyForceX86"))))
{
  $exeName = $exeName64
}
else
{
  $exeName = $exeName32
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName  
  fileFullPath   = [System.IO.Path]::Combine($installDir, $exeName)
  url            = 'http://oblique-audio.com/downloads/' + $exeName32
  checksum       = '5D7F341B8B84F23A5AC547210878489B7E70BC1BA820A78A4C4BD2F2B80A11DE'
  checksumType   = 'sha256'
  url64          = 'http://oblique-audio.com/downloads/' + $exeName64
  checksum64     = 'AE3BDE45FDB803E36D91A5604366AD4FD7C91DF4B492958D3B4FE79481407091'
  checksumType64 = 'sha256'
}

Get-ChocolateyWebFile @packageArgs
