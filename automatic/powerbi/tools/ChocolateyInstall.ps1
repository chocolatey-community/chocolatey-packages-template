$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   url            = 'https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup.exe'
   url64bit       = 'https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup_x64.exe'
   checksum       = '3fc528109ad31ab62dbf6149d273b6071956f5fd66759b078b0f2a30e52a8249'
   checksumType   = 'SHA256'
   checksum64     = 'bdf72230cd3456a3fa9edfb833e77a94f32ad591c5846970cefd530e0fa16317'
   fileType       = 'EXE'
   silentArgs     = "-quiet -norestart ACCEPT_EULA=1 -log `"$env:TEMP\$env:ChocolateyPackageName.$env:chocolateyPackageVersion.Install.log`""
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
