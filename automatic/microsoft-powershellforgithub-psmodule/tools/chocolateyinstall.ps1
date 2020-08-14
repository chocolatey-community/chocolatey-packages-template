$ErrorActionPreference = 'Stop'

$packageName = 'microsoft-powershellforgithub-psmodule'
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$exe         = "$ENV:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"

$PSversion = $PSVersionTable.PSVersion.Major
if ($PSversion -lt "4"){
   Write-Warning "  ** PowerShell < v4 detected."
	Write-Warning "  ** $packageName installs via the PowerShell Gallery and thus requires PowerShell v4+."
	throw
}

if (Get-Module -ListAvailable -Name "PowerShellForGitHub" -ErrorAction SilentlyContinue){
   # Will fail if packageVersion is a revised version not matching module version, i.e. x.x.x.0020180101
   Update-Module "PowerShellForGitHub" -RequiredVersion "$ENV:packageVersion" -Force
} else {   
   Get-PackageProvider -Name NuGet -Force
   Install-Module -Name "PowerShellForGitHub" -Scope AllUsers -RequiredVersion $ENV:packageVersion -AllowClobber -Force
}
