$ErrorActionPreference = 'Stop';

$additionalArgs = ''
$packageParameters = Get-PackageParameters

# see if any parameters were passed
if ($packageParameters['GenerateConfig']) { $GenerateConfig = $packageParameters['GenerateConfig'] }
if ($packageParameters['LicenseKey']) { $LicenseKey = $packageParameters['LicenseKey'] }
if ($packageParameters['DisplayName']) { $DisplayName = $packageParameters['DisplayName'] }
if ($packageParameters['Proxy']) { $Proxy = $packageParameters['Proxy'] }
if ($packageParameters['CustomAttributes']) { $CustomAttributes = $packageParameters['CustomAttributes'] }

if(Get-Variable -Name GenerateConfig -ErrorAction SilentlyContinue) {
  $additionalArgs = 'GENERATE_CONFIG=true'

  if(Get-Variable -Name LicenseKey -ErrorAction SilentlyContinue) {
    $additionalArgs += " LICENSE_KEY=$LicenseKey"
  }

  if(Get-Variable -Name DisplayName -ErrorAction SilentlyContinue) {
    $additionalArgs += " DISPLAY_NAME=$DisplayName"
  }

  if(Get-Variable -Name Proxy -ErrorAction SilentlyContinue) {
    $additionalArgs += " PROXY=$Proxy"
  }

  if(Get-Variable -Name CustomAttributes -ErrorAction SilentlyContinue) {
    $additionalArgs += " CUSTOM_ATTRIBUTES=$CustomAttributes"
  }
}


$packageName     = 'newrelic-infra'
$softwareName    = 'newrelic-infra*'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://download.newrelic.com/infrastructure_agent/windows/newrelic-infra.1.11.37.msi'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url64bit      = $url64

  softwareName  = $softwareName

  checksum64     = '25f48365e88f166e2451c07ee14e21c69e8ec656283b988abbd1c2ec6e1f236f'
  checksumType64 = 'sha256'

  silentArgs    = "/qn $additionalArgs /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
