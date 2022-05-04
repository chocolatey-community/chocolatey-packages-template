$ErrorActionPreference = 'Stop'

$packageVersion = "1.6.10"

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'msi'
  url64bit               = "https://github.com/cryptomator/cryptomator/releases/download/$packageVersion/Cryptomator-$packageVersion-x64.msi"
  checksum64 = '2a17d9d0ab0db8ede457e5dfa236a2e34a1ddcfd16dc3c99bb61f70e9f3c724c'
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




