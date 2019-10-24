$ErrorActionPreference = 'Stop';

$unzip_folder    = $env:ProgramFiles
$install_folder  = "$unzip_folder\telegraf"
$configDirectory = Join-Path $install_folder 'telegraf.d'
$packageName     = 'telegraf'
$softwareName    = 'telegraf*'
$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url             = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.12.4_windows_i386.zip'
$url64           = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.12.4_windows_amd64.zip'
$fileLocation    = Join-Path $install_folder 'telegraf.exe'

If(!(Test-Path -Path $configDirectory)){
  New-Item -Path $configDirectory -ItemType Directory
}

If (Get-Service -Name "telegraf" -ErrorAction SilentlyContinue) {
    & $fileLocation --service uninstall
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

  checksum       = '290c1efaa7f90111ee5957aa5b9bc0332b250e56bafe06158d6861b2cf5a99b0'
  checksumType   = 'sha256'
  checksum64     = 'b656b0859c29f536f5dc1d0ac7aadf50fd719d7ff3406778823e5c04cad8e0e3'
  checksumType64 = 'sha256'

  silentArgs     = "--config-directory `"$configDirectory`" --service install"
  validExitCodes= @(0)
}

Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs
