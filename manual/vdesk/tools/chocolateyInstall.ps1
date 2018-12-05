$packageArgs = @{
  packageName   = 'vdesk'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = 'https://github.com/eksime/VDesk/releases/download/v1.2.0/VDeskSetup.msi'
  silentArgs    = '/qn /norestart'
  validExitCodes= @(0)
  softwareName  = 'VDesk*'
  checksum      = 'F3971A8845F3BAABF2D988187F17FFE21B0397B17E4A68FB1AD92BC6010FDE6F'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs