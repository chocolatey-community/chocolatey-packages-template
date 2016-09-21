$url          = 'https://images-na.ssl-images-amazon.com/images/G/01/digital/music/morpho/installers/20160616/222132fbc5/AmazonMusicInstaller.exe'
$checksum     = 'E908889E16E5B0C58B670BB74AB6E3F8AC48F5BEA2D59899665439FCD5504A63'
$toolsDir     = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$fileFullPath = Join-Path $toolsDir 'AmazonMusicInstaller.exe'

Get-ChocolateyWebFile -PackageName 'amazonmusic' -FileFullPath $fileFullPath -Url $url -Checksum $checksum -ChecksumType 'sha256'

$installArgs = '--unattendedmodeui none'
start-process $fileFullPath $installArgs