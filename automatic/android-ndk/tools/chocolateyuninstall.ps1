$url        = 'https://dl.google.com/android/repository/android-ndk-r19c-windows-x86.zip'
$url64      = 'https://dl.google.com/android/repository/android-ndk-r19c-windows-x86_64.zip'

If(Get-OSArchitectureWidth -Compare 32) {
  $zipFileName = $url.split('/')[-1]
} Else {
  $zipFileName = $url64.split('/')[-1]
}

$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName = $env:ChocolateyPackageName
  zipFileName = $zipFileName
}

$uninstalled = $false

Uninstall-ChocolateyEnvironmentVariable -VariableName 'ANDROID_NDK_ROOT'

Uninstall-ChocolateyZipPackage @packageArgs
