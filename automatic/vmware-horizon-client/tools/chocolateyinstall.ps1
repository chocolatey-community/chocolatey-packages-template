$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.vmware.com/software/CART23FQ2_WIN_2206/VMware-Horizon-Client-2206-8.6.0-20094380.exe'
$checksum               = '7cb28f642c25050d209e4411d21d6d778c4b24005eab03d687c4a3444befdbb7'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  url                   = $url
  softwareName          = "VMware Horizon Client*"
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/silent /norestart'
  validExitCodes        = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
