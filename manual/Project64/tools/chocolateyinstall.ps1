$ErrorActionPreference = 'Stop';

$packageName= 'Project64'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://www.pj64-emu.com/file/setup-project64-v2-3-2-202-g57a221e/'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'Project64*'

  checksum      = '14139367A84B4EC6F7EAA89A82D96DBEC4B264BCC83D822CC886AD5210D151C8'
  checksumType  = 'sha256'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
