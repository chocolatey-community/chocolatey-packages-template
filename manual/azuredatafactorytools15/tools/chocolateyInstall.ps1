"$ErrorActionPreference = 'Stop'"

$packageArgs = @{
  packageName   = 'azuredatafactorytools15'
  vsixUrl       = 'https://visualstudiogallery.msdn.microsoft.com/371a4cf9-0093-40fa-b7dd-be3c74f49005/file/182173/6/AzureDataFactoryVisualStudioTools-VS2015.vsix'
  vsVersion     =  14
  checksum      = '095C4ECD7BC1796D497920385BD198B4231388616F9458A919F593CC84D74B89'
  checksumType  = 'sha256'
}

Install-ChocolateyVsixPackage @packageArgs