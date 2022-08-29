$ErrorActionPreference = 'Stop'

$toolsDir            = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                 = 'https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x86.msi'
$checksum            = 'fddab92f98e08e2cae0e025f4cf2cdd5f0d87c8dfc5719045933d8f0130aff4d'
$checksumType        = 'sha256'
$url64               = 'https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x64.msi'
$checksum64          = '0001dd763cc74d37e3979e016ffcd0512d91494a0b3b7270c7a3bb4e1915f6d1'
$checksumType64      = 'sha256'

$pp                  = Get-PackageParameters

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  softwareName   = "Local Account Password Solution*"
  url            = $url
  url64bit       = $url64
  validExitCodes = @(0, 3010)
  silentArgs     = '/qn /norestart'
  checksum       = $checksum
  checksumType   = $checksumType
  checksum64     = $checksum64
  checksumType64 = $checksumType64

if ( $pp.ALL ) {
  Write-Host "`nInstalling Microsoft Local Account Password Solution with Management Tools...`n" -ForegroundColor Yellow

  $packageArgs['silentArgs'] = 'ADDLOCAL=ALL /qn /norestart'

} else {
  Write-Host "`nInstalling Microsoft Local Account Password Solution...`n" -ForegroundColor Yellow
}

Install-ChocolateyPackage @packageArgs
