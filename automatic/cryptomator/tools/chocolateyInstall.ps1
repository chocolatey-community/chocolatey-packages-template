$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'exe'
  url                    = 'https://bintray.com/cryptomator/cryptomator/download_file?file_path=Cryptomator-1.3.3-x86.exe'
  url64bit               = 'https://bintray.com/cryptomator/cryptomator/download_file?file_path=Cryptomator-1.3.3-x64.exe'
  checksum               = '3E6E7F147556EB2399837F7903E2C50D859995B2F386C37265B8B1C5088EE18E'
  checksum64             = 'D2505FCC071AE220494312939000C682A3DB263F216CD33A273E78E85407EE38'
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

