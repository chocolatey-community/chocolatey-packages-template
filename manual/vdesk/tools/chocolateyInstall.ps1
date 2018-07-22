$packageArgs = @{
  packageName   = 'vdesk'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = 'https://github.com/eksime/VDesk/releases/download/v1.1.2/VDeskSetup.msi'
  silentArgs    = '/qn /norestart'
  validExitCodes= @(0)
  softwareName  = 'VDesk*'
  checksum      = '3870FBF7217D0FBD5B7B66B4C6C017926AB3CB6B93247CF665255B52661B09A0'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs