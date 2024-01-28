$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName  
  url            = 'https://oblique-audio.com/downloads/RTL_Utility_1_0_8_Win32.exe'
  checksum       = '6ab7bf722c7d0186c62a4771f8cb4bdc65d263bef812de572c9c7ad4155ed4fc'
  checksumType   = 'sha256'
  url64          = 'https://oblique-audio.com/downloads/RTL_Utility_1_0_8_x64.exe'
  checksum64     = '6ab7bf722c7d0186c62a4771f8cb4bdc65d263bef812de572c9c7ad4155ed4fc'
  checksumType64 = 'sha256'
}

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$pp = Get-PackageParameters

$installDir = $toolsPath
if ($pp.InstallDir)
{ 
  $installDir = $pp.InstallDir
}
Write-Host "$env:ChocolateyPackageName is going to be installed in '$installDir'"

# Exe name is platform dependant - leave in URL for automatic updater
if ((Get-ProcessorBits -ge 64) -and
    ([String]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable("chocolateyForceX86"))))
{
  $exeName = [System.IO.Path]::GetFileName($packageArgs['url64'])
}
else
{
  $exeName = [System.IO.Path]::GetFileName($packageArgs['url'])
}   
# Full file path is only known after exe name
$packageArgs['fileFullPath'] = [System.IO.Path]::Combine($installDir, $exeName)

Get-ChocolateyWebFile @packageArgs
