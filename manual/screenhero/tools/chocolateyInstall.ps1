$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$exeFile = "Screenhero-Latest-setup.exe"

$packageArgs = @{
  packageName   = 'screenhero'
  unzipLocation = "$unzipLocation"
  fileType      = 'exe'
  url           = "$(Join-Path $unzipLocation $exeFile)"
  silentArgs    = '/Q'
  validExitCodes= @(0)
  softwareName  = 'screenhero*'
}

Install-ChocolateyPackage @packageArgs