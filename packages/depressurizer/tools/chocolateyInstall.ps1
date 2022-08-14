$ErrorActionPreference = 'Stop';

$packageName = 'depressurizer'
$url = "https://github.com/Depressurizer/Depressurizer/releases/download/v5.2.0/Depressurizer-v5.2.0.exe"
$checksum = '8254bdeae5cac5bf8b75f4a59f1d42cb4152961eb5170526ce483c03759375c5'


$destination = "$env:LOCALAPPDATA\programs\Depressurizer"
mkdir $destination -Force

Get-ChocolateyWebFile `
    -PackageName $packageName `
    -FileFullPath "$destination\Depressurizer.exe" `
    -ForceDownload `
    -Url $url `
    -Checksum $checksum `
    -ChecksumType 'sha256' `

Install-ChocolateyShortcut -ShortcutFilePath "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Depressuzizer.lnk" -TargetPath "$destination\Depressurizer.exe"
