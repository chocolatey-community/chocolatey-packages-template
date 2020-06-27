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
  url                   = 'https://github.com/cfillion/reapack/releases/download/v1.2.3/reaper_reapack-x86.dll'
  checksum              = '988986CE5AB6E3B3AA3CC1C8D8302D78AC5F94B8F9B43B7EC3A163D5AF085B9C'
  checksumType          = 'sha256'
  url64                 = 'https://github.com/cfillion/reapack/releases/download/v1.2.3/reaper_reapack-x64.dll'
  checksum64            = '1E6761E648B376E30DFB8AC9F15D05FB3679C81D501ABA9B4B43F74E8316691D'
  checksumType64        = 'sha256'  
}

Get-ChocolateyWebFile @packageArgs
