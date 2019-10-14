$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName    = 'imgburn'
  unzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType       = 'EXE'
  url            = 'http://files2.majorgeeks.com/d846362a19c234c4f710eb9d3b11d702500587e7/cddvd/SetupImgBurn_2.5.8.0.exe'
  checksum       = '49AA06EAFFE431F05687109FEE25F66781ABBE1108F3F8CA78C79BDEC8753420'
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
