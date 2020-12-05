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
  url                   = 'https://github.com/cfillion/reapack/releases/download/v1.2.3.1/reaper_reapack-x86.dll'
  checksum              = '4dc467cbf2c7335c59312ccd6938270090c9f006ad58b305cd752381592d9280'
  checksumType          = 'sha256'
  url64                 = 'https://github.com/cfillion/reapack/releases/download/v1.2.3.1/reaper_reapack-x64.dll'
  checksum64            = '67b003b7635f13cb1c25afadaa967b6b0143baf67119424bffdd166b5bf26044'
  checksumType64        = 'sha256'  
}

Get-ChocolateyWebFile @packageArgs
