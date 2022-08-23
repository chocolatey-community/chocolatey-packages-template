$packageName       = $env:ChocolateyPackageName
$toolsDir          = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$webToolsDir       = Join-Path $toolsDir $packageName
$packageWebConfig  = Join-Path $webToolsDir 'Web.config'
$webInstallDir     = Join-Path (Get-ToolsLocation) $packageName
$existingWebConfig = Join-Path $webInstallDir 'Web.config'

If (Test-Path $existingWebConfig) {
  Write-Output "Copying existing web.config to package directory to allow proper updates"
  Copy-Item $existingWebConfig $packageWebConfig -Force -ErrorAction SilentlyContinue
}