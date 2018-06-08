$checksum = 'cbbc2626452f4130d64e10093dd3428e08ee90700203ff60ed919f2795848d64'
$url = 'https://downloads.plex.tv/plex-media-server/1.13.2.5142-3ba6662e9/Plex-Media-Server-1.13.2.5142-3ba6662e9.exe'

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
