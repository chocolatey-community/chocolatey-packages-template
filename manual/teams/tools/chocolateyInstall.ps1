$packageArgs = @{
  packageName    = 'teams'
  unzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType       = 'EXE'
  url            = 'https://statics.teams.microsoft.com/production-windows/1.0.00.8201/Teams_windows.exe'
  url64bit       = 'https://statics.teams.microsoft.com/production-windows-x64/1.0.00.6903/Teams_windows_x64.exe'
  checksum       = 'A2E274F215343070B88210CC1A0D51344961A832A2E4ABD7E06D170496A23FFF'
  checksumType   = 'sha256'
  checksum64     = '08F034A08BB826A5E3217E5487593F95399BEBD69DBB9C5514A5C59E3A922CFF'
  checksumType64 = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs