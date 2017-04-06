$packageArgs = @{
  packageName    = 'sublimetext2'
  unzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType       = 'EXE'
  url            = 'https://download.sublimetext.com/Sublime%20Text%202.0.2a%20Setup.exe'
  url64bit       = 'https://download.sublimetext.com/Sublime%20Text%202.0.2a%20x64%20Setup.exe'
  checksum       = '73334A65B7EA12992DBFC014A62DB18814AD1F0BCF3E9282F175CB8478AD2850'
  checksumType   = 'sha256'
  checksum64     = '5F13EDC7DCE7D3FC6BC42D7545ABAC89D7EF4D4F3884C479F64CC28D95E353D2'
  checksumType64 = 'sha256'
  silentArgs     = '/VERYSILENT /NORESTART /TASKS="contextentry"'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs