$ErrorActionPreference = 'Stop'

$packageVersion = "1.6.7"

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'msi'
  url64bit               = "https://github.com/cryptomator/cryptomator/releases/download/$packageVersion/Cryptomator-$packageVersion-x64.msi"
  checksum64 = 'e170c2fa1f47170efe853ff4f5b05763271ff335b6e0c50b976ca02d5bb67b79'
  checksumType64         = 'sha256'
  silentArgs             = '/qn /norestart'
  validExitCodes         = @(0)
  registryUninstallerKey = 'Cryptomator'
}
Install-ChocolateyPackage @packageArgs

$installLocation = Get-AppInstallLocation $packageArgs.registryUninstallerKey
if ($installLocation)  {
    Write-Host "$packageName installed to '$installLocation'"
}
else { Write-Warning "Can't find $PackageName install location" }

