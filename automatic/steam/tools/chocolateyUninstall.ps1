$ErrorActionPreference = 'Stop'
$packageName = 'steam'
$installerType = 'EXE'
$silentArgs = '/S'
$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64
$validExitCodes = @(0)

try {
	if ($is64bit) {
		$unpath = "${Env:ProgramFiles(x86)}\Steam\uninstall.exe"
	} else {
		$unpath = "$Env:ProgramFiles\Steam\uninstall.exe"
	}
	Uninstall-ChocolateyPackage $packageName $installerType $silentArgs $unpath -validExitCodes $validExitCodes
	Write-ChocolateySuccess $packageName
} catch {
	Write-ChocolateyFailure $packageName $($_.Exception.Message)
	throw	
}
