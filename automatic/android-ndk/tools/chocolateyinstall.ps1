
$ErrorActionPreference = 'Stop';

$packageParameters = Get-PackageParameters

$is64bit = Get-ProcessorBits 64

$androidPath = "${Env:SystemDrive}\Android"

# set default installation path if not passed
if (!$packageParameters['InstallationPath']) { $packageParameters['InstallationPath'] = "${androidPath}" }

$installationPath = $packageParameters['InstallationPath']

$url = 'https://dl.google.com/android/repository/android-ndk-r21d-windows-x86_64.zip'

$folderName = (Split-Path $url -Leaf).replace('-windows-x86_64.zip','')

$packageName  = 'android-ndk'
$softwareName = 'android-ndk*'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $installationPath
  url           = $url

  softwareName  = $softwareName

  checksum      = '18335e57f8acab5a4acf6a2204130e64f99153015d55eb2667f8c28d4724d927'
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
