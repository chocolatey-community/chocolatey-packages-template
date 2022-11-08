$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName  
  url            = 'https://oblique-audio.com/downloads/RTL_Utility_1_0_5_Win32.exe'
  checksum       = 'a0ccb7a49ae417ca6d36e30e7fb0d2cf283e80b55a059210eb62cfd2be1092c7'
  checksumType   = 'sha256'
  url64          = 'https://oblique-audio.com/downloads/RTL_Utility_1_0_5_x64.exe'
  checksum64     = '27db26ecbeb309ce0183b570ec47a5aefa5e3276b7e65cea49f9d6790bb3928f'
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
