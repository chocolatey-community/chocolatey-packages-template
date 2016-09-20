$checksum = '14AB9B659DBB14D88759B0F9CD39926FFF0D21E778014D1EB22FAA7C0EEAACB1'

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