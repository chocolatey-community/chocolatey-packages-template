# Run installer
$packageName = 'Git-Credential-Manager-for-Windows'
$url = 'https://github.com/Microsoft/Git-Credential-Manager-for-Windows/releases/download/v1.5.0/GCMW-1.5.0.exe'
$installerType = 'exe'
$silentArgs = '/SILENT /NORESTART'

Install-ChocolateyPackage $packageName $installerType $silentArgs $url