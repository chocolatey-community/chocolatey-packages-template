$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'exe'
  url                    = 'https://bintray.com/cryptomator/cryptomator/download_file?file_path=Cryptomator-1.3.0-x86.exe'
  url64bit               = 'https://bintray.com/cryptomator/cryptomator/download_file?file_path=Cryptomator-1.3.0-x64.exe'
  checksum               = 'e5bc8e1e0e0d81660b329157c9435240eca08313b75bb8cc277da1caa9f5ef59'
  checksum64             = '6970c7b40f3e87b415a80bfe2c9b906effba3518c2d9672724cf5c9c5bc0de18'
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

