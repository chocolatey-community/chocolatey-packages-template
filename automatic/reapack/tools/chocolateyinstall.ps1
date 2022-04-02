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
  url                   = 'https://github.com/cfillion/reapack/releases/download/v1.2.4/reaper_reapack-x86.dll'
  checksum              = '012402b2390a79f15836acf65a589ab3a88007f8733fd476fffb7158f8994538'
  checksumType          = 'sha256'
  url64                 = 'https://github.com/cfillion/reapack/releases/download/v1.2.4/reaper_reapack-x64.dll'
  checksum64            = '125a1eac2ca569661336fb3e37ec50b531ba24c4ee9e8abe5d65d702f5b4a445'
  checksumType64        = 'sha256'  
}

Get-ChocolateyWebFile @packageArgs
