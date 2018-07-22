$packageArgs = @{
  packageName   = 'flashdevelop'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://www.flashdevelop.org/downloads/releases/FlashDevelop-5.3.3.exe'
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'FlashDevelop*'
  checksum      = '7B3109DD768C0C2EF285A0D4A019AB4E89D58F0229A3B820D72F363E7EE3DE38'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs