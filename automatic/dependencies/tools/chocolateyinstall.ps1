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
  url            = 'https://github.com/lucasg/Dependencies/releases/download/v1.11/Dependencies_x86_Release.zip'
  checksum       = 'd3e75e1e2c549aeafa0cfa9d147d494eb85a08da84ae4e6e2bb9b089c9ebf620'
  checksumType   = 'sha256'
  url64          = 'https://github.com/lucasg/Dependencies/releases/download/v1.11/Dependencies_x64_Release.zip'
  checksum64     = '820215f3107c135635ded01de2fb0785797cf1fe5fae1cedb6f0afc42f91881b'
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
