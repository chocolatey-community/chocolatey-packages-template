$ErrorActionPreference = 'Stop';

$packageName= 'Project64'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://www.pj64-emu.com/downloads/func-download/125'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'Project64*'

  checksum      = 'FE8397EB045B92C450ABED075D98CC90CF3137461E410A65407AE8D2152BDCFD'
  checksumType  = 'sha256'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
