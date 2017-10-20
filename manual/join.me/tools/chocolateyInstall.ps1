$packageArgs = @{
  packageName   = 'join.me'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = 'https://www.join.me/Download.aspx?installer=win&webdownload=true'
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'join.me*'
}

Install-ChocolateyPackage @packageArgs