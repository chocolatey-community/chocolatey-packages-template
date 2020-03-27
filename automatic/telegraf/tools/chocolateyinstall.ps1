$ErrorActionPreference = 'Stop';

$unzip_folder    = $env:ProgramFiles
$install_folder  = "$unzip_folder\telegraf"
$configDirectory = Join-Path $install_folder 'telegraf.d'
$packageName     = 'telegraf'
$softwareName    = 'telegraf*'
$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url             = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.14.0_windows_i386.zip'
$url64           = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.14.0_windows_amd64.zip'
$fileLocation    = Join-Path $install_folder 'telegraf.exe'
$telegrafRegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\telegraf"

If(!(Test-Path -Path $configDirectory)){
  New-Item -Path $configDirectory -ItemType Directory
}

If (Get-Service -Name "telegraf" -ErrorAction SilentlyContinue) {
    & $fileLocation --service uninstall
}

If (Test-Path $telegrafRegPath) {
    Remove-Item $telegrafRegPath -Force
}

If (Test-Path "$env:ProgramFiles\telegraf\telegraf.conf" -ErrorAction SilentlyContinue) {
  Copy-Item -Force -Path "$env:ProgramFiles\telegraf\telegraf.conf" -Destination "$env:ProgramFiles\telegraf\telegraf.backup.conf"
}

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $unzip_folder
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64
  file          = $fileLocation
  file64        = $fileLocation

  softwareName  = 'telegraf*'

  checksum       = '9adb550f1a6536d33e3a977b779a3380d5af3ecb80d56d8333b44a0ba02cabfb'
  checksumType   = 'sha256'
  checksum64     = '018c54442d6a84c4153c4ff02727eee5cdc70262bae449505be7ba7299ef55e8'
  checksumType64 = 'sha256'

  silentArgs     = "--config-directory `"$configDirectory`" --service install"
  validExitCodes= @(0)
}

Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs

If (Test-Path "$env:ProgramFiles\telegraf\telegraf.backup.conf" -ErrorAction SilentlyContinue) {
  Move-Item -Force -Path "$env:ProgramFiles\telegraf\telegraf.backup.conf" -Destination "$env:ProgramFiles\telegraf\telegraf.conf"
  Restart-Service -Name "telegraf"
}
