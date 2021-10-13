$ErrorActionPreference = 'Stop';

$packageName= 'Project64'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://www.pj64-emu.com/file/setup-project64-3-0-0-5632-f83bee9/'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'Project64*'

  checksum      = '93F3DB8DC5642D39FCC44EAF43811CDBDF912690F95041E924E038E76F36F921'
  checksumType  = 'sha256'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
