$packageArgs = @{
  packageName   = 'join.me'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = 'https://raw.githubusercontent.com/mikecole/chocolatey-packages/master/join.me/join.me.msi'
  silentArgs    = '/quiet /norestart'
  validExitCodes= @(0)
  softwareName  = 'join.me*'
  checksum      = '24021AB33772E42B170AF165AC0E8A778CD89B18B0B6DC9844C7C4F023832FD6'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs