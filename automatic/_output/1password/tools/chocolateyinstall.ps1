$ErrorActionPreference = 'Stop';
$packageName= '1password' # arbitrary name for the package, used in messages
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = 'https://d13itkw33a7sus.cloudfront.net/dist/1P/win4/1Password-4.6.0.604.exe'
  softwareName  = '1Password*'
  checksum      = '3c6f9f51f5a4c44ceced089cdee8c840f18d96f652b4fe95e16d166859767076'
  checksumType  = 'sha256'
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs