$ErrorActionPreference = 'Stop';

$url            = 'https://binaries.webex.com/jabberclientwindows/20220728022045/CiscoJabberSetup.msi'
$checksum_url   = '6043C529A225380C1DFAE438969643B62D80AF856D9B4BDCD1C9DAF02EFB3140'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'msi'
  url           = $url
  checksum      = $checksum_url
  checksumType  = 'sha256'
  softwareName  = 'Cisco Jabber*'
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
}
Install-ChocolateyPackage @packageArgs