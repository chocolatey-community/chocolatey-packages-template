$packageName = 'crystalreports-for-visualstudio'
$installerType = 'MSI'
$url = 'https://downloads.businessobjects.com/akdlm/cr4vs2010/CRforVS_13_0_22.exe'
$checksum = 'E05CDA365DD11DE1E279DDF58113F7612B4E5DA6970D228F32E415296D2F2F2E'
$silentArgsSDK = "/q /l ""$env:temp\$packageName-SDK.log"" UPGRADE=1"
$silentArgsRuntime = "/q /l ""$env:temp\$packageName-Runtime.log"" UPGRADE=1"

$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

Get-ChocolateyWebFile 'crystalreports-for-visualstudio' "$toolsDir\CRforVS_13_0_22.exe" "$url" -Checksum "$checksum" -ChecksumType 'sha256'
Get-ChocolateyUnzip "$toolsDir\CRforVS_13_0_22.exe" "$toolsDir\CRforVS_13_0_22"
Remove-Item "$toolsDir\CRforVS_13_0_22.exe"

$sdkFileFullPath = get-childitem $toolsDir -recurse -include CrystalReportsForVisualStudio.msi | select -First 1
Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgsSDK" "$sdkFileFullPath"

$is64bit = Get-ProcessorBits 64;
if ($is64bit) {
	$runtimeFileFullPath = get-childitem $toolsDir -recurse -include CRRuntime_64bit_13_0_22.msi | select -First 1
	Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgsRuntime" "$runtimeFileFullPath"
}

Remove-Item "$toolsDir\CRforVS_13_0_22" -recurse