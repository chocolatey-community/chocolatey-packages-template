
$ErrorActionPreference = 'Stop';
$url32 = 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/d491c8d8-730d-47ed-bf64-58144fca727b/MicrosoftEdgeEnterpriseX86.msi'
$url64 = 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/d1ec9411-fa61-4946-a93d-b0db1ae42cf4/MicrosoftEdgeEnterpriseX64.msi'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'MSI'
  url            = $url32
  url64bit       = $url64

  softwareName   = 'Microsoft Edge'

  checksum       = '38851A83F670B0AFA9C0F23F2CD3678BFF7B970F96CE81942DA96018599D8C91'
  checksumType   = 'sha256'
  checksum64     = '9FB32426503C31B5D59BF3365CAE8003B46487E9B411FAB8DB5C115270A9A4FD'
  checksumType64 = 'sha256'

  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs