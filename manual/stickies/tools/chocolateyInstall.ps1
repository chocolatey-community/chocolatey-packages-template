$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileFullPath = Join-Path $toolsDir 'stickies_setup_9.0c.exe'

$packageArgs = @{
  packageName    = 'stickies'
  fileFullPath   = $fileFullPath
  url            = 'http://www.zhornsoftware.co.uk/stickies/stickies_setup_9.0c.exe'
  checksum       = 'B0862703109A1B70E8A1E88953AB1C868F89E46775BF2D0DB084A2D9EC267364'
  checksumType   = 'sha256'
}

Get-ChocolateyWebFile @packageArgs

# AutoIt
$installerFile = Join-Path $toolsDir 'stickies.au3'
write-host "Installing `'$fileFullPath`' with AutoIt3 using `'$installerFile`'"
$installArgs = "/c autoit3 `"$installerFile`" `"$fileFullPath`""
Start-ChocolateyProcessAsAdmin -Statements "$installArgs" -ExeToRun 'cmd.exe' -ValidExitCodes @(0)