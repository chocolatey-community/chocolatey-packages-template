$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'msi'
  url64bit               = 'https://github.com/cryptomator/cryptomator/releases/download/1.6.4/Cryptomator-1.6.4-x64.msi'
  checksum64             = '9916865AF48FE94E2AAFF8A12B00412B9E10F86FF4327B5D16AADD7B6EEAFB63'
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
