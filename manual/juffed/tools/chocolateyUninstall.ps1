$ErrorActionPreference = 'Stop'

$installFolder = "$(Get-ToolsLocation)\JuffEd_0.8.1"

$desktop = $([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::DesktopDirectory))

$installShortcut = "$desktop\JuffEd.lnk";

if (Test-Path $installFolder) {
  Remove-Item -Force -Recurse -ea 0 $installFolder
}

if (Test-Path $installShortcut) {
  Remove-Item -Force -ea 0 $installShortcut
}