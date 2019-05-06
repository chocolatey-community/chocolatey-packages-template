$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = 'line'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://dl.desktop.line.naver.jp/naver/LINE/win/LineInst.exe'
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'Line*'
  checksum      = '9DB00043599AD16635A3FCA8C0A9EA8C2AA26FEAD0CF1B10C4E3D640C81FB9EE'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs