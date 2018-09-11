$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'cryptomator'
  fileType               = 'exe'
  url                    = 'https://bintray.com/cryptomator/cryptomator/download_file?file_path=Cryptomator-1.3.4-x86.exe'
  url64bit               = 'https://bintray.com/cryptomator/cryptomator/download_file?file_path=Cryptomator-1.3.4-x64.exe'
  checksum               = 'F5B2C3EAE83A065079781644583552C62C9780113A049C37C656568647441FF5'
  checksum64             = '265CD890A28BD54DF91BD011D1BD0F899DCD29F661BDE7E26B9C26FB918119BD'
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

