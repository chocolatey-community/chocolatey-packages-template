## Template VirtualEngine.Build ChocolateyInstall.ps1 file for EXE/MSI installations
$installChocolateyPackageParams = @{
    PackageName    = 'Citrix-Receiver';
    FileType       = 'EXE';
    SilentArgs     = '/noreboot /silent';
    Url            = 'https://downloadplugins.citrix.com/Windows/CitrixReceiver.exe';
    ValidExitCodes = @(0,3010);
    Checksum       = 'ADB1AFF0625F6EE0C9745F6F8C523398CF3F4732EB3D2CA5966E97AE6D57536F';
    ChecksumType   = 'sha256';
}
Install-ChocolateyPackage @installChocolateyPackageParams;