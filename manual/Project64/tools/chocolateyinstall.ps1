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

  checksum      = '591AE9FE2C073D452F8EB08CBE5A9705224F131EADEB553E270A50A11592FD11'
  checksumType  = 'sha256'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
