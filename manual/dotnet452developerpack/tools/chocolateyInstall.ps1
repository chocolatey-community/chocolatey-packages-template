$packageArgs = @{
  packageName   = 'dotnet452developerpack'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = 'https://download.microsoft.com/download/B/4/1/B4119C11-0423-477B-80EE-7A474314B347/NDP452-KB2901954-Web.exe'
  silentArgs    = '/q'
  validExitCodes= @(0)
  softwareName  = 'dotnet452developerpack*'
  checksum      = 'BD173D14A371E6786C4AE90BE1F2C560458D672BA4CBEB3CF55BEBFEF2E2778A'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs