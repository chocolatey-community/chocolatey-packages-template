$packageArgs = @{
  packageName   = 'meinberg-ntp'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://www.meinbergglobal.com/download/ntp/windows/ntp-4.2.8p11-win32-setup.exe'
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'Network Time Protocol*'
  checksum      = '56311644B8743EFD7EFDE78F849931F3E9A404822120E6A6F42C5889B8FA0F75'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs