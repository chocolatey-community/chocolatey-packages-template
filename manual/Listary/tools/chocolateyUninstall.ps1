$packageName = 'Listary'
$uninstallerType = 'exe'
$silentArgs = '/SP /VERYSILENT /NORESTART /SUPPRESSMSGBOXES'
$uninstallerFileName = 'unins000.exe'

$path = Join-Path -Path $env:programfiles -ChildPath "$packageName\$uninstallerFileName"
Uninstall-ChocolateyPackage "$packageName" "$uninstallerType" "$silentArgs" "$path"
