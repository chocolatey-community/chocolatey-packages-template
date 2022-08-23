Import-Module wormies-au-helpers

$changelog = (Get-Content -Encoding UTF8 "$PSScriptRoot\CHANGELOG.md" | Select-Object -Skip 2) -join "`n"
Update-Metadata -key 'releaseNotes' -value $changelog -NuspecFile "$PSScriptRoot\chocolatey-core.extension.nuspec"