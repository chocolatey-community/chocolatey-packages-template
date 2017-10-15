$checksum = '6c9742674672ee8994e5528c1d7e9f27049f4224f2779df124cdc80217d34d0e'
$url = 'https://downloads.plex.tv/plex-media-server/1.9.4.4325-1bf240a65/Plex-Media-Server-1.9.4.4325-1bf240a65.exe'

if ((get-process "Plex Media Server" -ea SilentlyContinue) -eq $Null){ 
    $PMSRunning="False" # Always false on new install.
   } else { 
    $PMSRunning="True"
    Write-Host "Plex Media Server found running." -foreground magenta 
}

$packageArgs = @{
  packageName   = 'plexmediaserver'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = $url
  silentArgs    = '/quiet'
  validExitCodes= @(0)
  softwareName  = 'plexmediaserver*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs

if ($PMSRunning -eq "True"){
    $bits = Get-ProcessorBits
	Write-Host "Running Plex Media Server" -foreground magenta 
    if ($bits -eq 64){
	& "${env:PROGRAMFILES(x86)}\Plex\Plex Media Server\Plex Media Server.exe"
       } else {
        & "$env:PROGRAMFILES\Plex\Plex Media Server\Plex Media Server.exe"
       }
}
