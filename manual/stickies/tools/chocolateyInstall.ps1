$packageArgs = @{
  packageName   = 'stickies'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://www.zhornsoftware.co.uk/stickies/stickies_setup_9.0e.exe'
  silentArgs    = '-silent'
  validExitCodes= @(0)
  softwareName  = 'stickies*'
  checksum      = 'F6B912B8E4166314DC032C7C16EE2CEC981D41592ABD03A3B42D30C2102E13A8'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs