# upgrade powershell
if ($PSVersionTable.PSVersion -lt $(New-Object System.Version("5.0.0.0"))) {
  choco install powershell -y
}

$UpdateSessionEnvironment = Get-Command Update-SessionEnvironment -ea SilentlyContinue
if ($UpdateSessionEnvironment -ne $null -and $UpdateSessionEnvironment.CommandType -ne 'Application') {
  Update-SessionEnvironment # You need the Chocolatey profile installed for this to work properly (Choco v0.9.10.0+).
} else {
  Write-Warning "We detected that you do not have the Chocolatey PowerShell profile installed, which is necessary for 'Update-SessionEnvironment' to work in PowerShell."
}

# Switch to this once chocolatey-au is released
# choco install chocolatey-au -y

choco install git.portable -y
# Required as git is installed to Get-ToolsLocation and is added to the PATH
Update-SessionEnvironment
git clone -q https://github.com/chocolatey-community/chocolatey-au.git $Env:TEMP/chocolatey-au
. "$Env:TEMP/chocolatey-au/scripts/Install-AU.ps1" "master"
