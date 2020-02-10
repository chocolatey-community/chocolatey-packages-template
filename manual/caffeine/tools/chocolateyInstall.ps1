$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = 'caffeine'
  unzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType       = 'zip'
  url            = 'http://www.zhornsoftware.co.uk/caffeine/caffeine.zip'
  validExitCodes = @(0)
  checksum       = 'B0982D0F2C106091010AED3CFF08643ACB6520E39A23F55A4BBD6CAC9990EAAD'
  checksumType   = 'sha256'
}

echo "If an older version of Caffeine is running on this machine, it will be closed prior to the installation of the newer version."
ps caffeine -ea 0 | kill

Install-ChocolateyZipPackage @packageArgs