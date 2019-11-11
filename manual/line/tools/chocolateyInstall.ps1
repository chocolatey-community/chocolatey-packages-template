$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = 'line'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://dl.desktop.line.naver.jp/naver/LINE/win/LineInst.exe'
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'Line*'
  checksum      = 'D9D236E12F488947ADCEE00966EA5C0BB88B8BB2691804E567B2B37F39E1DCF3'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs