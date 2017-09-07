$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'exe'
  url                    = 'https://bintray.com/cryptomator/cryptomator/download_file?file_path=Cryptomator-1.3.1-x86.exe'
  url64bit               = 'https://bintray.com/cryptomator/cryptomator/download_file?file_path=Cryptomator-1.3.1-x64.exe'
  checksum               = '4b4f18b9cc3afc9b433b90b7ad113d7e7bb3f41f737f5d8bf4176e5e0ab74be3'
  checksum64             = '4cf1165702e9c143b0490aa2e41beee448d39f1e6093ec6f17b988f98c3bffb4'
  checksumType           = 'sha256'
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

