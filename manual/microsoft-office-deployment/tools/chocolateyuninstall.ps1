# microsoft-office-deployment uninstall

$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    softwareName   = ''
    fileType       = ''
    silentArgs     = ''
    validExitCodes = @(0, 3010, 1605, 1614, 1641)
}

if ($key.Count -eq 1) {
    $key | ForEach-Object {
        $packageArgs['file'] = "$($_.UninstallString)"
        if ($packageArgs['fileType'] -eq 'MSI') {
          $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
          $packageArgs['file'] = ''
        }
        Uninstall-ChocolateyPackage @packageArgs
    }
} elseif ($key.Count -eq 0) {
    Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
    Write-Warning "$($key.Count) matches found!"
    Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
    Write-Warning "Please alert package maintainer the following keys were matched:"
    $key | ForEach-Object {Write-Warning "- $($_.DisplayName)"}
}

# Custome Settings from Package
## Remove files and folders
if (Get-Item -Path "<Path>" -ErrorAction SilentlyContinue) {
    Remove-Item `
        -Path "<Path>" `
        -Recurse
    Write-Output `
        -InputObject "Remove Shortcut <Path>"
}