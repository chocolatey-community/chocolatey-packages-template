$ErrorActionPreference = 'Stop';

$unzip_folder    = $env:ProgramFiles
$install_folder  = "$unzip_folder\telegraf"
$configDirectory = Join-Path $install_folder 'telegraf.d'
$packageName     = 'telegraf'
$softwareName    = 'telegraf*'
$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url             = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.13.4_windows_i386.zip'
$url64           = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.13.4_windows_amd64.zip'
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

  checksum       = '45c8c27fa32ca28334fe998d8ebe84a22fd57fca28ac14f2b691cc47fef93def'
  checksumType   = 'sha256'
  checksum64     = '1b037e144ab62857d2a1b94cb65d869ad1b7d4053bbdd6ff5525bc05a1ed9728'
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
