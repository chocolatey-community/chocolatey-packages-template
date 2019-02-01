$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileFullPath = Join-Path $toolsDir 'clickie.exe'

$packageArgs = @{
  packageName    = 'clickie'
  fileFullPath   = $fileFullPath
  url            = 'http://www.defoort.com/images/software/clickie/clickie32.exe'
  url64bit       = 'http://www.defoort.com/images/software/clickie/clickie64.exe'
  checksum       = 'AAEE8859258AE96400777CE69389581923D4300702F314B7F69A99C16E5B36D1'
  checksumType   = 'sha256'
  checksum64     = '82A291AF01B5A53EE62E077D48BB59B4EF15DA5D2A0B1DEDBB5F08CADB4696BD'
  checksumType64 = 'sha256'
}

Get-ChocolateyWebFile @packageArgs

# AutoIt
$installerFile = Join-Path $toolsDir 'clickie.au3'
write-host "Installing `'$fileFullPath`' with AutoIt3 using `'$installerFile`'"
$installArgs = "/c autoit3 `"$installerFile`" `"$fileFullPath`""
Start-ChocolateyProcessAsAdmin -Statements "$installArgs" -ExeToRun 'cmd.exe' -ValidExitCodes @(0)