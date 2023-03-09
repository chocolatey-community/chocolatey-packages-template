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

# Enable TLS 1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

$packageName     = 'newrelic-infra'
$softwareName    = 'newrelic-infra*'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://download.newrelic.com/infrastructure_agent/windows/newrelic-infra.1.38.0.msi'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url64bit      = $url64

  softwareName  = $softwareName

  checksum64     = '9e0dff96904419dabb597f3b4c85cc89c24893a15b0a420228a8a463ffc0866d'
  checksumType64 = 'sha256'

  silentArgs    = "/qn $additionalArgs /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
