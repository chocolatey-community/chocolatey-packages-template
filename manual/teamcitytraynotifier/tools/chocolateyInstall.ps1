$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$msiFile = "TrayNotifierInstaller.msi"

$packageArgs = @{
  packageName   = 'teamcitytraynotifier'
  unzipLocation = "$unzipLocation"
  fileType      = 'msi'
  url           = "$(Join-Path $unzipLocation $msiFile)"
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'teamcitytraynotifier*'
}

Install-ChocolateyPackage @packageArgs