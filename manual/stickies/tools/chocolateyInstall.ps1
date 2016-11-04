$packageArgs = @{
  packageName   = 'stickies'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'http://www.zhornsoftware.co.uk/stickies/stickies_setup_9.0c.exe'
  silentArgs    = '-silent'
  validExitCodes= @(0)
  softwareName  = 'stickies*'
  checksum      = 'B0862703109A1B70E8A1E88953AB1C868F89E46775BF2D0DB084A2D9EC267364'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs