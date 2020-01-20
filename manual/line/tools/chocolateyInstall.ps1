$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = 'line'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://dl.desktop.line.naver.jp/naver/LINE/win/LineInst.exe'
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'Line*'
  checksum      = 'FE1982479699D4DA776DB2998FE1E79AA5C932973658F6A4190A69D86B47EC67'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs