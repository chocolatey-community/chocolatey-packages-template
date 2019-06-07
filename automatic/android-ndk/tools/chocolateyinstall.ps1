
$ErrorActionPreference = 'Stop';

$packageParameters = Get-PackageParameters

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$androidPath = "${Env:SystemDrive}\Android\android-ndk"

# set default installation path if not passed
if (!$packageParameters['InstallationPath']) { $packageParameters['InstallationPath'] = "${androidPath}" }

$pathElements = $packageParameters['InstallationPath'].split("\")

$installationPath = $pathElements[0..($pathElements.count-2)] -join "\"
$installationFolder = $pathElements[-1]


$url        = 'https://dl.google.com/android/repository/android-ndk-r19c-windows-x86.zip'
$url64      = 'https://dl.google.com/android/repository/android-ndk-r19c-windows-x86_64.zip'

If(Get-OSArchitectureWidth -Compare 32) {
  $zipFileName = $url.split('/')[-1]
} Else {
  $zipFileName = $url64.split('/')[-1]
}

If(Get-OSArchitectureWidth -Compare 32) {
  $folderName = $url.split('/')[-1].replace('-windows-x86.zip','')
} Else {
  $folderName = $url64.split('/')[-1].replace('-windows-x86_64.zip','')
}

$packageName = 'android-ndk'
$softwareName = 'android-ndk*'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $installationPath
  url           = $url
  url64bit      = $url64

  softwareName  = $softwareName

  checksum      = '800c3c6ba616ddf25097d43566d5d574f9e6c0a10538bf60dd5be0e024f732cd'
  checksumType  = 'sha256'
  checksum64    = '0faf708c9837a921cae5262745f5857162614bb9689a0d188780d12ea93a2c18'
  checksumType64= 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

$packagelibPath = $env:ChocolateyPackageFolder

# the folder name in the zip file is named after the version, so renaming it
Rename-Item -Path "$installationPath\$folderName" -NewName "$installationPath\$installationFolder"

# update the list of extracted files in the chocolatey text file with the new path
((Get-Content -path "$packagelibPath\$($zipFileName).txt" -Raw) `
  -replace "$($installationPath.replace("\","\\"))\\$folderName","$installationPath\$installationFolder") `
  | Set-Content -Path "$packagelibPath\$($zipFileName).txt"

Install-ChocolateyEnvironmentVariable `
  -VariableName 'ANDROID_NDK_ROOT' `
  -VariableValue "$installationPath\$installationFolder"
