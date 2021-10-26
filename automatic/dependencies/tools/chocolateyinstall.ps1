$ErrorActionPreference = 'Stop';

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$pp = Get-PackageParameters

$installDir = $toolsPath
if ($pp.InstallDir)
{ 
  $installDir = $pp.InstallDir
}
Write-Host "$env:ChocolateyPackageName is going to be installed in '$installDir'"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName  
  unzipLocation  = $installDir
  url            = 'https://github.com/lucasg/Dependencies/releases/download/v1.11.1/Dependencies_x86_Release.zip'
  checksum       = '3e6bc62b4163c4e8035e8a597515c116343fcb76fa4315317c3cafe0bdc9e257'
  checksumType   = 'sha256'
  url64          = 'https://github.com/lucasg/Dependencies/releases/download/v1.11.1/Dependencies_x64_Release.zip'
  checksum64     = '7d22dc00f1c09fd4415d48ad74d1cf801893e83b9a39944b0fce6dea7ceaea99'
  checksumType64 = 'sha256'  
}

Install-ChocolateyZipPackage @packageArgs

if (-Not $pp.NoStartMenu) {
  Write-Verbose "Creating start menu entry"
  $linkfiles = get-childitem "$installDir" -include "*Gui.exe" -recurse

  # This will create a Link for selected exe and will add a line chocoUninstall.ps1 to remove it on uninstall
  foreach ($file in $linkfiles) {
    Write-Verbose "Crating Start Menu enty for $($file.BaseName)"
    $newlink ="$($env:ProgramData)\Microsoft\Windows\Start Menu\Programs\$($file.BaseName).lnk"
    Install-ChocolateyShortcut -shortcutFilePath $newlink -targetPath "$file"
    Add-Content "$toolsPath\chocoUninstall.ps1" -Value "Remove-Item `"$($newlink)`" -Force -ea ignore"
  }
}
