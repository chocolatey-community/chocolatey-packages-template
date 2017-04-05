$packageArgs = @{
  packageName   = 'stickies'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://www.zhornsoftware.co.uk/stickies/stickies_setup_9.0d.exe'
  silentArgs    = '-silent'
  validExitCodes= @(0)
  softwareName  = 'stickies*'
  checksum      = '5BC755FEDFA8FBED9F4F04F657CDAD2738253924B613C6D121BD4EE4F0723805'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs