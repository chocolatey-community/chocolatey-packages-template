$oldVersion = $args[0]
$newVersion = $args[1]
$checksum = $args[2]

Write-Host $newVersion
$thisPath = $MyInvocation.MyCommand.Path
$cryptomatorPath = [IO.Path]::Combine($thisPath, '..', '..')

Write-Host $cryptomatorPath

$nuspecPath = [IO.Path]::Combine($cryptomatorPath, 'cryptomator.nuspec')
$oldNuspecContent = Get-Content -path $nuspecPath -Raw
$newNuspecContext = $oldNuspecContent -replace "$oldVersion","$newVersion"
Set-Content -Path $nuspecPath -Value $newNuspecContext

$installScriptPath = [IO.Path]::Combine($cryptomatorPath, 'tools', 'chocolateyInstall.ps1')
$oldInstallContent = Get-Content -Path $installScriptPath -Raw
$newInstallContent = $oldInstallContent -replace "packageVersion = ""$oldVersion""","packageVersion = ""$newVersion"""
$newInstallContent = $newInstallContent -replace "checksum64\s*=\s*'\S*'","checksum64 = '$checksum'"
Set-Content -Path $installScriptPath -Value $newInstallContent
