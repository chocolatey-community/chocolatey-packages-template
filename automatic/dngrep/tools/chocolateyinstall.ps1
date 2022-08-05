$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName    = 'dngrep'
  fileType       = 'msi'
  file           = gi $toolsDir\*x86.msi
  file64         = gi $toolsDir\*x64.msi
  silentArgs     = '/quiet'
}
Install-ChocolateyInstallPackage @packageArgs
rm $toolsDir\*.msi -ea 0

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation "$packageName*"
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\$packageName.exe"
Write-Host "$packageName registered as $packageName"