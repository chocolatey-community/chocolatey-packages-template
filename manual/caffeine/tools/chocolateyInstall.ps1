$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = 'caffeine'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'zip'
  url           = 'http://www.zhornsoftware.co.uk/caffeine/caffeine.zip'
  validExitCodes= @(0)
  checksum      = '5CBAAEFAF4C24D3AF73B856C98B079FF4BCDF01CA104B179733FCA0616A05D8D'
  checksumType  = 'sha256'
}

echo "If an older version of Caffeine is running on this machine, it will be closed prior to the installation of the newer version."
ps caffeine -ea 0| kill

Install-ChocolateyZipPackage @packageArgs