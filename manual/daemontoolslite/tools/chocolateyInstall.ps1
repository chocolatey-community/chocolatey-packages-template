$packageArgs = @{
  packageName   = 'daemontoolslite'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://mirror22.daemon-tools.cc/getfile.php?p=http://na-us7.disc-tools.com/60457c29cf1b5ce4d4c48f55ee0577f9/DTLiteInstaller.exe'
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'DAEMON Tools Lite*'
  checksum      = 'AD8D1D25FBB5A3F2E531CB30BA543756FC09D70978D48C728A866FAD4A27E007'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs