$ErrorActionPreference = 'Stop';

$unzip_folder    = $env:ProgramFiles
$install_folder  = "$unzip_folder\telegraf"
$configDirectory = Join-Path $install_folder 'telegraf.d'
$packageName     = 'telegraf'
$softwareName    = 'telegraf*'
$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url             = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.14.1_windows_i386.zip'
$url64           = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.14.1_windows_amd64.zip'
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

  checksum       = 'f32a133ce3f83176470dff0df6fc5c321835737c812f55cb464175c163cd0c38'
  checksumType   = 'sha256'
  checksum64     = '43a8caa82028e511db0b8684e7a0d637438692e368854e56772eba496b9b3b40'
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
