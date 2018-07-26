$packageArgs = @{
  packageName   = 'netfx-4.5.2-devpack'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://download.microsoft.com/download/4/3/B/43B61315-B2CE-4F5B-9E32-34CCA07B2F0E/NDP452-KB2901951-x86-x64-DevPack.exe'
  silentArgs    = "/Quiet /NoRestart /Log $($env:temp)\netfx-4.5.2-devpack.txt"
  validExitCodes= @(0,3010)
  softwareName  = 'netfx-4.5.2-devpack*'
  checksum      = '127725B8E955E764BA08E87706D0B0DF6B52CFFF45BBA7D2B7DA09DF55D16166'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs