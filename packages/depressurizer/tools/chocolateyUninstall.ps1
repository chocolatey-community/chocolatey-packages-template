$ErrorActionPreference = 'Stop';

$destination = "$env:LOCALAPPDATA\programs\Depressurizer"
Remove-Item -Recurse $destination -Force
Remove-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Depressuzizer.lnk" -Force
