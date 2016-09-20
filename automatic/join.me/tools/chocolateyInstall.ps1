$checksum = 'CFA50618FD3719C0C46A898939663095E44A477FAA7E9A4151BCD3B579C727E6'

$packageArgs = @{
  packageName   = 'join.me'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://www.join.me/Download.aspx'
  silentArgs    = '/VERYSILENT'
  validExitCodes= @(0)
  softwareName  = 'join.me*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
