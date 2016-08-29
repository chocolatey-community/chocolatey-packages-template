$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileFullPath = Join-Path $toolsDir 'AmazonMusicInstaller.exe'

$packageArgs = @{
  packageName    = 'amazonmusic'
  fileFullPath   = $fileFullPath
  url           = 'https://images-na.ssl-images-amazon.com/images/G/01/digital/music/morpho/installers/20160616/222132fbc5/AmazonMusicInstaller.exe'
  checksum      = 'E908889E16E5B0C58B670BB74AB6E3F8AC48F5BEA2D59899665439FCD5504A63'
  checksumType  = 'sha256'
}

Get-ChocolateyWebFile @packageArgs

write-host "Installing `'$fileFullPath`'"
$installArgs = '--unattendedmodeui none'
start-process $fileFullPath $installArgs
Set-PowerShellExitCode 0