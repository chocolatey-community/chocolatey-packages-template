$ErrorActionPreference = 'Stop';

$packageName = 'depressurizer'
$url = "https://github.com/Depressurizer/Depressurizer/releases/download/v5.2.0/Depressurizer-v5.2.0.exe"
$checksum = '8254bdeae5cac5bf8b75f4a59f1d42cb4152961eb5170526ce483c03759375c5'

$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = $url
    softwareName   = 'Depressurizer*'

    checksum       = $checksum
    checksumType   = 'sha256'

    silentArgs     = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
