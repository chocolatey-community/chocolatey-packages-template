$checksum = 'EDD02EEF77C869378EC7DAC7726DBA81E984C7FFEB22AAE95E8759998A9F5685'
$url = 'https://download.microsoft.com/download/5/A/7/5A7065A2-C81C-4A31-9972-8A31AC9388C1/SQLServer2017-SSEI-Dev.exe'

$packageArgs = @{
  packageName   = 'sql-server-developer'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = $url
  silentArgs    = '/IACCEPTSQLSERVERLICENSETERMS /Q /ACTION=install /HIDEPROGRESSBAR /VERBOSE'
  validExitCodes= @(0)
  softwareName  = 'Microsoft SQL Server 2017*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs