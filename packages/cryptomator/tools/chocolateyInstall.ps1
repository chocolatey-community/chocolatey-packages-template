$ErrorActionPreference = 'Stop'

$packageVersion = "1.6.11"

$url64bit = "https://github.com/cryptomator/cryptomator/releases/download/$packageVersion/Cryptomator-$packageVersion-x64.msi"
$checksum64 = 'aec875ddc2b869c546e69dbab3212c81dae57e8fa7f9fa00af9f143f85da6dcc'

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'msi'
  url64bit               = $url64bit
  checksum64             = $checksum64
  checksumType64         = 'sha256'
  silentArgs             = '/qn /norestart'
  validExitCodes         = @(0)
  registryUninstallerKey = 'Cryptomator'
}
Install-ChocolateyPackage @packageArgs

$installLocation = Get-AppInstallLocation $packageArgs.registryUninstallerKey
if ($installLocation) {
  Write-Host "$packageName installed to '$installLocation'"
}
else { Write-Warning "Can't find $PackageName install location" }
