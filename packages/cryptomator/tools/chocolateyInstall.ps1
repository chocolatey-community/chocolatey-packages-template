$ErrorActionPreference = 'Stop'

$packageVersion = "1.6.8"

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'msi'
  url64bit               = "https://github.com/cryptomator/cryptomator/releases/download/$packageVersion/Cryptomator-$packageVersion-x64.msi"
  checksum64 = '6f0321d8f7eb9db13ad726354c87fa39b3d895e0895d4f05c6e38d3f584453f8'
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


