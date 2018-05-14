$tempDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = 'directx'
  unzipLocation = $tempDir
  fileType      = 'exe'
  url           = 'https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe'
  silentArgs    = "/Q /T:$tempDir"
  validExitCodes= @(0)
  softwareName  = 'directx*'
  checksum      = '8746EE1A84A083A90E37899D71D50D5C7C015E69688A466AA80447F011780C0D'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs

# Run the actual installer
$dxSetup = Join-Path $tempDir 'DXSETUP.exe'
Install-ChocolateyInstallPackage 'directx' 'exe' '/silent' "$dxSetup"