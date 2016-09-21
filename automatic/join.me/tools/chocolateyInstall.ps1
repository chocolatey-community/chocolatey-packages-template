$checksum = '87370ca1c100461e332150673412e7befaf1bb9ecb13ef7daec6dfb1ad064bf2'

$packageArgs = @{
  packageName   = 'join.me'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = 'https://www.join.me/Download.aspx?installer=win&webdownload=true'
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'join.me*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
