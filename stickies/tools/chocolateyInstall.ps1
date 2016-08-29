$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileFullPath = Join-Path $toolsDir 'stickies_setup_9.0b.exe'

$packageArgs = @{
  packageName    = 'stickies'
  fileFullPath   = $fileFullPath
  url            = 'http://www.zhornsoftware.co.uk/stickies/stickies_setup_9.0b.exe'
  checksum       = '34E22C85A4DF4A2CFEF743589212B423CA60D84F1C14AA9AFB4682ADF5A2CA31'
  checksumType   = 'sha256'
}

Get-ChocolateyWebFile @packageArgs

# AutoIt
$installerFile = Join-Path $toolsDir 'stickies.au3'
write-host "Installing `'$fileFullPath`' with AutoIt3 using `'$installerFile`'"
$installArgs = "/c autoit3 `"$installerFile`" `"$fileFullPath`""
Start-ChocolateyProcessAsAdmin -Statements "$installArgs" -ExeToRun 'cmd.exe' -ValidExitCodes @(0)