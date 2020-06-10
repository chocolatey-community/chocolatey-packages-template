$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'exe'
  url64bit               = 'https://dl.bintray.com/cryptomator/cryptomator/1.5.5/Cryptomator-1.5.5-x64.exe'
  checksum64             = '9DBA5F9373F3890DC750C71CD658B935DB9DFE557315A7B9AD40FF284A4BFD10'
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

