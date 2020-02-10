$ErrorActionPreference = 'Stop'

$checksum = '98C6E2590B9DCFB160B2A37D794DA7F704E7C4B63BFD79FAE98B59DC3B0CC648'
$url = 'https://phoenixnap.dl.sourceforge.net/project/juffed/Releases/0.8.1/JuffEd_0.8.1.zip'
$unzipLocation = "$(Get-ToolsLocation)"

$zipArgs = @{
  packagename = 'juffed'
  url = $url
  unzipLocation = $unzipLocation 
  checksum = $checksum
  checksumType = "sha256"
}

Install-ChocolateyZipPackage @zipArgs

$desktop = $([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::DesktopDirectory))

Install-ChocolateyShortcut `
  -ShortcutFilePath "$desktop\JuffEd.lnk" `
  -TargetPath "$unzipLocation\JuffEd_0.8.1\juffed.exe"