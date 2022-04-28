$ErrorActionPreference = 'Stop'

$packageVersion = "1.6.9"

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'msi'
  url64bit               = "https://github.com/cryptomator/cryptomator/releases/download/$packageVersion/Cryptomator-$packageVersion-x64.msi"
  checksum64 = 'efef1aaee085aaeaabcf3ccbf25d80d610282e6185f5cfc8a842b0c822eef7e5'
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



