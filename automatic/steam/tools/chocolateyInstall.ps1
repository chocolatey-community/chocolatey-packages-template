$ErrorActionPreference = 'Stop'
$checksum = '3bc6942fe09f10ed3447bccdcf4a70ed369366fef6b2c7f43b541f1a3c5d1c51'

Start-CheckandStop "Steam"

$packageArgs = @{
  packageName   = 'steam'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://media.steampowered.com/client/installer/SteamSetup.exe'
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'steam*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs

if ($ProcessWasRunning -eq "True") {&$ProcessFullPath}
