$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = 'azuredatafactorytools15'
  vsixUrl       = 'https://azuredatafactory.gallerycdn.vsassets.io/extensions/azuredatafactory/microsoftazuredatafactorytoolsforvisualstudio2015/0.9.3527.2/1482142461622/182173/9/AzureDataFactoryVisualStudioTools-VS2015.vsix'
  vsVersion     =  14
  checksum      = '095C4ECD7BC1796D497920385BD198B4231388616F9458A919F593CC84D74B89'
  checksumType  = 'sha256'
}

Install-ChocolateyVsixPackage @packageArgs