$configFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'configuration.xml')
Install-ChocolateyPackage 'officeClickToRun' 'exe' "/extract:$env:temp\office /log:$env:temp\officeInstall.log /quiet /norestart" 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_9326.3600.exe' -checksum '631F0303E9B47B49A7C1ECBE60615CE0E63421EFA5FE9BC2B2A71478FE219858' -checksumType 'sha256'
Install-ChocolateyInstallPackage 'officeClickToRun' 'exe' "/download $configFile" "$env:temp\office\setup.exe"
Install-ChocolateyInstallPackage 'officeClickToRun' 'exe' "/configure $configFile" "$env:temp\office\setup.exe"
