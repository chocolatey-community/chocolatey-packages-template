$checksum = 'b8bf6ae2f17265fdd2e0befbf4d51032249b0e990561aa2438dbe6811e5568ea'
$url = 'https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.76.9/mRemoteNG-Installer-1.76.9.25377.msi'

$packageArgs = @{
  packageName   = 'mremoteng'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = $url
  silentArgs    = '/quiet /norestart'
  validExitCodes= @(0)
  softwareName  = 'mremoteng*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
