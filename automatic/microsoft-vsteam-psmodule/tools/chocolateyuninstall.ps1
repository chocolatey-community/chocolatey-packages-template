$ErrorActionPreference = 'Stop'

$packageName  = 'microsoft-vsteam-psmodule'

Get-InstalledModule -Name "VSTeam" |  Uninstall-Module -AllVersions -Force
