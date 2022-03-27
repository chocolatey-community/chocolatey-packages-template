$ErrorActionPreference = 'Stop';

$packageName   = 'depressurizer'
$url           = 'https://github.com/Depressurizer/Depressurizer/releases/download/$env:chocolateyPackageVersion/Depressurizer-v$env:chocolateyPackageVersion.zip'

# TODO - This package is now just an executable that needs to be downloaded and put in the path, also create a shortcut

# Write-Output "Adding shortcut to Start Menu"
# Install-ChocolateyShortcut -ShortcutFilePath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\EarTrumpet.lnk" -TargetPath $exePath

# $packageArgs = @{
#   packageName   = $packageName
#   unzipLocation = $toolsDir
#   fileType      = 'exe'

#   softwareName  = 'Depressurizer*'

#   checksum = '178c3edf3d49f4e76b67e1ee9b9984eef21a079cbf1a732b99c7bc42a7eec762'
#   checksumType  = 'sha256'

#   silentArgs   = '/S'
#   validExitCodes= @(0)
# }

# Install-ChocolateyPackage @packageArgs
