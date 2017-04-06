$packageArgs = @{
  packageName    = 'imgburn'
  unzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType       = 'EXE'
  url            = 'http://download.imgburn.com/SetupImgBurn_2.5.8.0.exe'
  checksum       = 'B0D8AA5D5A4B7B58BA4516812A82A8C1E2385353347B701D19DC3F89FDB7F4B1'
  checksumType   = 'sha256'
  silentArgs     = '/S /NOCANDY'
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs