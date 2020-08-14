$ErrorActionPreference = 'Stop'

$packageName = 'microsoft-vsteam-psmodule'
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$exe         = "$ENV:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"

$PSversion = $PSVersionTable.PSVersion.Major
if ($PSversion -lt "5"){
   Write-Warning "  ** PowerShell < v5 detected."
   Write-Warning "  ** $packageName installs via the PowerShell Gallery and thus requires PowerShell v5+."
   Write-Warning "  ** If PowerShell v5 was installed as a dependency, you need to reboot and reinstall this package."
	throw
}

if (Get-Module -ListAvailable -Name "VSTeam" -ErrorAction SilentlyContinue){
   # Will fail if packageVersion is a revised version not matching module version, i.e. x.x.x.0020180101
   Update-Module "VSTeam" -RequiredVersion "$ENV:packageVersion" -Force
} else {   
   Get-PackageProvider -Name NuGet -Force
   Install-Module -Name "VSTeam" -Scope AllUsers -RequiredVersion $ENV:packageVersion -AllowClobber -Force
}
