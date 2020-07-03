
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

if (Test-Path $toolsdir\chocoUninstall.ps1) {
    . $toolsdir\chocoUninstall.ps1
}
