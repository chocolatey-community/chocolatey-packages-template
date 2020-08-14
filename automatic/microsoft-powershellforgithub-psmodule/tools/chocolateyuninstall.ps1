$ErrorActionPreference = 'Stop'

$packageName  = 'microsoft-powershellforgithub-psmodule'

Get-InstalledModule -Name "PowerShellForGitHub" |  Uninstall-Module -AllVersions -Force
