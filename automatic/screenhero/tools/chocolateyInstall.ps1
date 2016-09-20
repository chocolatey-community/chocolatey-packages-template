$checksum = 'deec3194aa144b92fa3c4dcf0ea674cf11db87c92b51ce5166b9c91205baa611'

$packageArgs = @{
  packageName   = 'screenhero'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://dl.screenhero.com/update/win/Screenhero-Latest-setup.exe'
  silentArgs    = '/Q'
  validExitCodes= @(0)
  softwareName  = 'screenhero*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
