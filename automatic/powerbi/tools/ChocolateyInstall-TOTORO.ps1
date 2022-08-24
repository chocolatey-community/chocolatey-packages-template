$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   url            = 'https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup.exe'
   url64bit       = 'https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup_x64.exe'
   checksum       = '473a846cd708454195964df52c1f12fa1627c15c8d2105ef9eb17b09b2ed8897'
   checksumType   = 'SHA256'
   checksum64     = '9352f6721698bec88ca4e3ececbe4c2bf2a72755df681ff58c8430c186956264'
   fileType       = 'EXE'
   silentArgs     = "-quiet -norestart ACCEPT_EULA=1 -log `"$env:TEMP\$env:ChocolateyPackageName.$env:chocolateyPackageVersion.Install.log`""
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
