$ErrorActionPreference = 'Stop'

$packageName = 'copyq'

$fileType      = 'exe'
$toolsDir      = Split-Path $MyInvocation.MyCommand.Definition
$embedded_path = gi "$toolsDir\*.$fileType"

$pp = Get-PackageParameters
$tasks=@()
if (!$pp.NoStartup)     { Write-Host 'Automatically start with Windows'; $tasks += 'startup'}
if (!$pp.NoDesktopIcon) { Write-Host 'Create desktop icon'; $tasks += 'desktopicon' }

$packageArgs = @{
  packageName    = $packageName
  fileType       = $fileType
  file           = $embedded_path
  silentArgs     = '/VERYSILENT /TASKS=' + ($tasks -join ',')
  validExitCodes = @(0)
  softwareName   = $packageName
}
Install-ChocolateyInstallPackage @packageArgs
rm $embedded_path -ea 0

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\$packageName.exe"
Write-Host "$packageName registered as $packageName"

start "$installLocation\$packageName.exe"
