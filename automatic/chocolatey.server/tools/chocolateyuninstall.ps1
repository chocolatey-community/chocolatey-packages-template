$packageName   = $env:ChocolateyPackageName
$webInstallDir = Join-Path (Get-ToolsLocation) $packageName

if (Test-Path $webInstallDir) {
  try {
    Write-Debug "Removing all but the App_Data folder in the existing '$webInstallDir'"
    Get-ChildItem -Path "$webInstallDir" -Recurse | % {
      if ($_.FullName -match 'App_Data' -or $_.FullName -match 'Web.config') {
        Write-Debug " - Skipping $($_.FullName)"
      } else {
        Write-Debug " - Removing $($_.FullName)"
        Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
      }
    }
  }
  catch {
    Write-Warning "Had an error deleting files from '$webInstallDir'. You will need to manually remove files. Error: $_"
  }

  Write-Warning "Removed all from '$webInstallDir' except for App_Data. You should inspect and remove packages/logs manually."
}