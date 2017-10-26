$checksum = '148d3c2a917eef8972f2ac1d6c7243f8add4232d58f6e5109f18829a74274329'

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
