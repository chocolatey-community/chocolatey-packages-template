$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'exe'
  url                    = 'https://bintray.com/cryptomator/cryptomator/download_file?file_path=Cryptomator-1.2.3-x86.exe'
  url64bit               = 'https://bintray.com/cryptomator/cryptomator/download_file?file_path=Cryptomator-1.2.3-x64.exe'
  checksum               = '2a375317a4850c42447e62bee623ed57f0187be029fac510aa36bbaecbdb9b66'
  checksum64             = '9732168a48506353f0a9fb1fb01f5e70a5fa113eb47a05f04db05f4c8b6ffbbf'
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

