$packageArgs = @{
  packageName    = 'imgburn'
  unzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType       = 'EXE'
  url            = 'http://download.imgburn.com/SetupImgBurn_2.5.8.0.exe'
  checksum       = 'D7DEA2819EDC77BC44DB637CD324E61942B54930CB3034F8F1A417B7DD27B514'
  checksumType   = 'sha256'
  silentArgs     = '/S /NOCANDY'
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs