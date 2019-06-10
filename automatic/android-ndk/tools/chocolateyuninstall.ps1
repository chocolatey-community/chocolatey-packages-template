$url        = 'https://dl.google.com/android/repository/android-ndk-r20-windows-x86.zip'
$url64      = 'https://dl.google.com/android/repository/android-ndk-r20-windows-x86_64.zip'

If(Get-OSArchitectureWidth -Compare 32) {
  $zipFileName = Split-Path $url -Leaf
} Else {
  $zipFileName = Split-Path $url64 -Leaf
}

$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName = $env:ChocolateyPackageName
  zipFileName = $zipFileName
}

$uninstalled = $false

Uninstall-ChocolateyEnvironmentVariable -VariableName 'ANDROID_NDK_ROOT'

Uninstall-ChocolateyZipPackage @packageArgs
