$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'exe'
  url64bit               = 'https://dl.bintray.com/cryptomator/cryptomator/1.5.11/Cryptomator-1.5.11-x64.exe'
  checksum64             = '41003DEE3843D1BF68E4506DAD77440252F4B83C43E7042A4BF12BAA2E2B3806'
  checksumType64         = 'sha256'
  silentArgs             = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes         = @(0)
  registryUninstallerKey = 'Cryptomator'
}
Install-ChocolateyPackage @packageArgs

$installLocation = Get-AppInstallLocation $packageArgs.registryUninstallerKey
if ($installLocation)  {
    Write-Host "$packageName installed to '$installLocation'"
}
else { Write-Warning "Can't find $PackageName install location" }
