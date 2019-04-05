$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = 'line'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://dl.desktop.line.naver.jp/naver/LINE/win/LineInst.exe'
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'Line*'
  checksum      = 'C38DB8D7004BF79CA51BE8BFFE5AAB85158DE09E4EB12DCF7C8B40B1EB346594'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs