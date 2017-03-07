$checksum = '7fafac858c7ac075594a42edf3423de8a129db6038c3614ff98bc4435e93f3c4'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.75Hotfix1/mRemoteNG-Installer-1.75.7000.19194.msi'

$packageArgs = @{
  packageName   = 'mremoteng'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = $url
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'mremoteng*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
