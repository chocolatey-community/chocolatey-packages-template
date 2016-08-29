$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$msiFile = "join.me.msi"

$packageArgs = @{
  packageName   = 'join.me'
  unzipLocation = "$unzipLocation"
  fileType      = 'msi'
  url           = "$(Join-Path $unzipLocation $msiFile)"
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'join.me*'
}

Install-ChocolateyPackage @packageArgs