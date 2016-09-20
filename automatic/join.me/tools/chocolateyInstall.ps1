$checksum = '14AB9B659DBB14D88759B0F9CD39926FFF0D21E778014D1EB22FAA7C0EEAACB1'

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
