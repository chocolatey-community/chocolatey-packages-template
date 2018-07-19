$packageArgs = @{
  packageName   = 'money-manager-ex'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://astuteinternet.dl.sourceforge.net/project/moneymanagerex/v1.3.3/mmex_1.3.3_x64_setup.exe'
  silentArgs    = '/VERYSILENT /NORESTART'
  validExitCodes= @(0)
  softwareName  = 'MoneyManagerEX*'
  checksum      = '645D945EFEBC8F61E5E3D6E3BEFA64265B6AF3042E170D27C5C4DC5DFD347FE4'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs