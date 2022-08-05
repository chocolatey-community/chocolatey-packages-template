
$ErrorActionPreference = 'Stop'; # stop on all errors

$packageArgs = @{
 packageName = 'pandoc'
 fileType = 'MSI'
 url = ''
 checksum = ''
 checksumType = 'sha512'
 silentArgs = '/qn'
 validExitCodes = @(0)
 softwareName = ''
}

Install-ChocolateyPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage