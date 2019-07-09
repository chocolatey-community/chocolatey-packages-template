$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = 'line'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://dl.desktop.line.naver.jp/naver/LINE/win/LineInst.exe'
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'Line*'
  checksum      = 'BBD1AEFC9EA4E22590F7CDBC8CE1411F343B7051149DFAB00346E53BADDCB3AD'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs