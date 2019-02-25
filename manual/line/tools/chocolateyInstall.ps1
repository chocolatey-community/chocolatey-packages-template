$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = 'line'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://dl.desktop.line.naver.jp/naver/LINE/win/LineInst.exe'
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'Line*'
  checksum      = '395F67AB0C6EC58CEE89FC302FCAF30D998ADD56A469863C4DF8836D7CFCB51D'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs