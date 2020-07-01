$ErrorActionPreference = 'Stop';

$unzip_folder    = $env:ProgramFiles
$install_folder  = "$unzip_folder\telegraf"
$configDirectory = Join-Path $install_folder 'telegraf.d'
$packageName     = 'telegraf'
$softwareName    = 'telegraf*'
$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url             = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.14.5_windows_i386.zip'
$url64           = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.14.5_windows_amd64.zip'
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

  checksum       = '37f154e74b2bca750803aea8e4417bc89eae6d8b47bce16c1babcb14277d1564'
  checksumType   = 'sha256'
  checksum64     = 'e5648afe957aee0cabf88fbd63dad7ba2bc3dac7ede2e09b246d78a9742793f8'
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
