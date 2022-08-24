$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
    packageName = $env:chocolateyPackageName
    file        = "$toolsPath/Wormies-AU-Helpers.7z"
    destination = "$env:TEMP/Wormies-AU-Helpers"
}

Get-ChocolateyUnzip @packageArgs

& "$($packageArgs.destination)/install.ps1"

# Copy the install item since we will use that when uninstalling the package
Copy-Item "$($packageArgs.destination)/install.ps1" $toolsPath -Force

Remove-Item $packageArgs.file, $packageArgs.destination -Force -Recurse