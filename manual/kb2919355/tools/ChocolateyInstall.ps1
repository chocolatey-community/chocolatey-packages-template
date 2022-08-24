$kb = "KB2919355"
$packageName = "KB2919355"
$silentArgs = "/quiet /norestart /log:`"$env:TEMP\$kb.Install.evt`""

$os = Get-WmiObject -Class Win32_OperatingSystem
$version = [Version]$os.Version

if ($version -eq $null -or $version -lt [Version]'6.3' -or $version -ge [Version]'6.4') {
	Write-Host "Skipping installation because this hotfix only applies to Windows 8.1 and Windows Server 2012 R2."
	return
}

if (Get-HotFix -id $kb -ea SilentlyContinue)
{
	Write-Host "Skipping installation because hotfix $kb is already installed."
	return
}

if ($os.ProductType -eq '1') {
	# Windows 8.1
	$url = "https://download.microsoft.com/download/4/E/C/4EC66C83-1E15-43FD-B591-63FB7A1A5C04/Windows8.1-KB2919355-x86.msu"
	$url64 = "https://download.microsoft.com/download/D/B/1/DB1F29FC-316D-481E-B435-1654BA185DCF/Windows8.1-KB2919355-x64.msu"
	$checksum = 'F8BECA5B463A36E1FEF45AD0DCA6A0DE7606930380514AC1852DF5CA6E3F6C1D'
	$checksum64 = 'B0C9ADA530F5EE90BB962AFA9ED26218C582362315E13B1BA97E59767CB7825D'
} else {
	# Windows Server 2012 R2
	$url64 = "https://download.microsoft.com/download/2/5/6/256CCCFB-5341-4A8D-A277-8A81B21A1E35/Windows8.1-KB2919355-x64.msu"
	$checksum64 = 'B0C9ADA530F5EE90BB962AFA9ED26218C582362315E13B1BA97E59767CB7825D'
}

Install-ChocolateyPackage $packageName 'msu' $silentArgs $url $url64 -checksum $checksum -checksum64 $checksum64 -checksumType 'sha256' -validExitCodes @(0, 3010, 0x80240017)
