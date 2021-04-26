$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'exe'
  url64bit               = 'https://github.com/cryptomator/cryptomator/releases/download/1.5.16/Cryptomator-1.5.16-x64.exe'
  checksum64             = 'BE9EFE5D615E9009B3FE7B4B20724CF7A08401D9D8CC9008187F58B03B7A3B47'
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
