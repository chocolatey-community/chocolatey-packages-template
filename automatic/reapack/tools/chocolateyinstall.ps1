$ErrorActionPreference = 'Stop';

$pp = Get-PackageParameters

# Default Reaper resource path
$installDir = [System.IO.Path]::Combine($Env:APPDATA, "REAPER")
if ($pp.ReaperResourcePath)
{ 
  $installDir = $pp.ReaperResourcePath
}
# Must be installed into user plugins subfolder
$installDir = [System.IO.Path]::Combine($installDir, "UserPlugins")

Write-Host "$env:ChocolateyPackageName is going to be installed in '$installDir'"

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName  
  fileFullPath          = [System.IO.Path]::Combine($installDir, "dummy_gets_replaced.dll");
  GetOriginalFileName   = $true
  url                   = 'https://github.com/cfillion/reapack/releases/download/v1.2.4.1/reaper_reapack-x86.dll'
  checksum              = 'e09e30b9b94686d681673aad40d00543f39b194b86a4cb88997bb6cb034c2e2b'
  checksumType          = 'sha256'
  url64                 = 'https://github.com/cfillion/reapack/releases/download/v1.2.4.1/reaper_reapack-x64.dll'
  checksum64            = 'cd9f7116b0aafcc4ec5d5b85af11d88cb4ed92852f492a35c8a3a2318a1d779d'
  checksumType64        = 'sha256'  
}

Get-ChocolateyWebFile @packageArgs
