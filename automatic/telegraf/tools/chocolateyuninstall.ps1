$ErrorActionPreference = 'Stop';

$packageName = 'telegraf'
$softwareName = 'telegraf*'
$installerType = 'EXE'
$install_folder = Join-Path $env:ProgramFiles 'telegraf'

$silentArgs = '--service uninstall'
$validExitCodes = @(0)

$uninstalled = $false

$file = Join-Path $install_folder 'telegraf.exe'

Uninstall-ChocolateyPackage -PackageName $packageName `
                            -FileType $installerType `
                            -SilentArgs "$silentArgs" `
                            -ValidExitCodes $validExitCodes `
                            -File "$file"

Start-Sleep -Seconds 3
Remove-Item -Path $install_folder -Recurse -Confirm:$false -Force
