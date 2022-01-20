
$ErrorActionPreference = 'Stop';

$packageParameters = Get-PackageParameters

$is64bit = Get-ProcessorBits 64

$androidPath = "${Env:SystemDrive}\Android"

# set default installation path if not passed
if (!$packageParameters['InstallationPath']) { $packageParameters['InstallationPath'] = "${androidPath}" }

$installationPath = $packageParameters['InstallationPath']

$url = 'https://dl.google.com/android/repository/android-ndk-r23b-windows.zip'

$folderName = (Split-Path $url -Leaf).replace('-windows-x86_64.zip','')

$packageName  = 'android-ndk'
$softwareName = 'android-ndk*'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $installationPath
  url           = $url

  softwareName  = $softwareName

  checksum      = '36270f8b2cfdd940f410bd8ffe6ce86ffaa8e87ff1c4fd4a8be5130268357778'
  checksumType  = 'sha256'
}

if ($is64bit) {
  Install-ChocolateyZipPackage @packageArgs

  Install-ChocolateyEnvironmentVariable `
    -VariableName 'ANDROID_NDK_ROOT' `
    -VariableValue "$installationPath\$folderName"
} else {
  throw $_.Exception
}
