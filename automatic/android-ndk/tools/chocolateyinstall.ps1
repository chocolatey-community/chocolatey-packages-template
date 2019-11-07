
$ErrorActionPreference = 'Stop';

$packageParameters = Get-PackageParameters

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$androidPath = "${Env:SystemDrive}\Android"

# set default installation path if not passed
if (!$packageParameters['InstallationPath']) { $packageParameters['InstallationPath'] = "${androidPath}" }

$installationPath = $packageParameters['InstallationPath']

$url        = 'https://dl.google.com/android/repository/android-ndk-r20b-windows-x86.zip'
$url64      = 'https://dl.google.com/android/repository/android-ndk-r20b-windows-x86_64.zip'

If(Get-OSArchitectureWidth -Compare 32) {
  $zipFileName = Split-Path $url -Leaf
} Else {
  $zipFileName = Split-Path $url64 -Leaf
}

If(Get-OSArchitectureWidth -Compare 32) {
  $folderName = (Split-Path $url -Leaf).replace('-windows-x86.zip','')
} Else {
  $folderName = (Split-Path $url64 -Leaf).replace('-windows-x86_64.zip','')
}

$packageName = 'android-ndk'
$softwareName = 'android-ndk*'

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $installationPath
  url            = $url
  url64bit       = $url64

  softwareName   = $softwareName

  checksum       = '58a79270e419c299c05084ec06d36c117e26b038b38bcde17af4ec3c45c29f5c'
  checksumType   = 'sha256'
  checksum64     = 'b9dd083aae7a29c887876ffb3840d4b192dee1a05ad9dbf545f2facd00b4e821'
  checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

$packagelibPath = $env:ChocolateyPackageFolder

Install-ChocolateyEnvironmentVariable `
  -VariableName 'ANDROID_NDK_ROOT' `
  -VariableValue "$installationPath\$folderName"
