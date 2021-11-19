$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName  
  url            = 'https://oblique-audio.com/downloads/RTL_Utility_1_0_2_Win32.exe'
  checksum       = '0ffe090938178088044860707cfa2160e2bac3c834b7f676137e5fda1a8cbbc6'
  checksumType   = 'sha256'
  url64          = 'https://oblique-audio.com/downloads/RTL_Utility_1_0_2_x64.exe'
  checksum64     = 'bcc565ed53aeb5d6d40c9d252a9954f16cde0dabdf821ef84b05ca1f93e9f4dc'
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
