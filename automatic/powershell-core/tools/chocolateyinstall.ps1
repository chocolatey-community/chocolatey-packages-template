$ErrorActionPreference = 'Stop';

$packageName= 'powershell-core'
$fileType = 'msi'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$Version = '7.0.6'
Try {
  [Version]$Version
  $InstallFolder = "$env:ProgramFiles\PowerShell\$($version.split('.')[0])"
  If (Test-Path "$InstallFolder\pwsh.exe")
  {
    If ((get-command "$InstallFolder\pwsh.exe").version -ge [version]$Version)
    {
      Write-output "The version of PowerShell in this package ($Version) is already installed by another means, marking package as installed"
      Exit 0
    }
  }  
}
Catch {
  Write-output "Note: This is a prelease package"
  $PreleasePackage = $true
  $InstallFolder = "$env:ProgramFiles\PowerShell\$($version.split('.')[0])-preview"
}


$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = $fileType
  url64      = 'https://github.com/PowerShell/PowerShell/releases/download/v7.0.6/PowerShell-7.0.6-win-x64.msi'
  checksum64    = '586E3B3D6A706A850C8883FCB1FDEA33C65402F82E3AB8EC8C877E7BF0098327'
  checksumType64= 'sha256'
  url           = 'https://github.com/PowerShell/PowerShell/releases/download/v7.0.6/PowerShell-7.0.6-win-x86.msi'
  checksum      = 'E98924EA4C5C72050D114E2CAF769AD25EF836CB8372CC70DF231FFA0CE9E11C'
  checksumType  = 'sha256'
  silentArgs    = '/qn', '/norestart', "/l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
  softwareName  = "PowerShell-7.*"
}

$pp = Get-PackageParameters

$pp.Keys.ForEach({
switch -RegEx ($_) {
'^CleanUpPath$'
  {
    Write-Host "/CleanUpSystemPath was used, removing all PowerShell Core path entries before installing"
    & "$toolsDir\Reset-PWSHSystemPath.ps1" -PathScope Machine, User -RemoveAllOccurances
    break
  }

'^(ADD_PATH)(=0|1)?"?$'
  { $packageArgs.silentArgs += ,($Matches[1] + @('=1',$Matches[2])[$Matches[2] -ne $null]); break }

'^(REGISTER_MANIFEST)(=0|1)?"?$'
  { $packageArgs.silentArgs += ,($Matches[1] + @('=1',$Matches[2])[$Matches[2] -ne $null]); break }

'^(ENABLE_PSREMOTING)(=0|1)?"?$'
  { $packageArgs.silentArgs += ,($Matches[1] + @('=1',$Matches[2])[$Matches[2] -ne $null]); break }

'^(ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL)(=0|1)?"?$'
  { $packageArgs.silentArgs += ,($Matches[1] + @('=1',$Matches[2])[$Matches[2] -ne $null]); break }

'^(ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL)(=0|1)?"?$'
  { $packageArgs.silentArgs += ,($Matches[1] + @('=1',$Matches[2])[$Matches[2] -ne $null]); break }

'^(USE_MU)(=0|1)?"?$'
  { $packageArgs.silentArgs += ,($Matches[1] + @('=1',$Matches[2])[$Matches[2] -ne $null]); break }

'^(ENABLE_MU)(=0|1)?"?$'
  { $packageArgs.silentArgs += ,($Matches[1] + @('=1',$Matches[2])[$Matches[2] -ne $null]); break }

default { Write-Error 'Parameter not recognized, halting...' -ErrorAction Stop } 
}})

if ($pp.Keys -notlike '*USE_MU*') { $packageArgs.silentArgs += ,"USE_MU=0" }
if ($pp.Keys -notlike '*ENABLE_MU*') { $packageArgs.silentArgs += ,"ENABLE_MU=0" }

Write-Warning "If you started this package under PowerShell core, replacing an in-use version may be unpredictable, require multiple attempts or produce errors."

Install-ChocolateyPackage @packageArgs

Write-Output "************************************************************************************"
Write-Output "*  INSTRUCTIONS: Your system default WINDOWS PowerShell version has not been changed."
Write-Output "*   PowerShell CORE $version, was installed to: `"$installfolder`""
If ($PreleasePackage) {
Write-Output "*   To start PowerShell Core PRERELEASE $version, at a prompt execute:"
Write-Output "*      `"$installfolder\pwsh.exe`""
Write-Output "*   IMPORTANT: Prereleases are not put on your path, nor made the default version of CORE."
}
else {
Write-Output "*   To start PowerShell Core $version, at a prompt or the start menu execute:"
Write-Output "*      `"pwsh.exe`""
Write-Output "*   Or start it from the desktop or start menu shortcut installed by this package."
Write-Output "*   This is your new default version of PowerShell CORE (pwsh.exe)."
}
Write-Output "************************************************************************************"

Write-Output "**************************************************************************************"
Write-Output "*  As of OpenSSH 0.0.22.0 Universal Installer, a script is distributed that allows   *"
Write-Output "*  setting the default shell for openssh. You could call it with code like this:     *"
Write-Output "*    If (Test-Path `"$env:programfiles\openssh-win64\Set-SSHDefaultShell.ps1`")         *"
Write-Output "*      {& `"$env:programfiles\openssh-win64\Set-SSHDefaultShell.ps1`" [PARAMETERS]}     *"
Write-Output "*  Learn more with this:                                                             *"
Write-Output "*    Get-Help `"$env:programfiles\openssh-win64\Set-SSHDefaultShell.ps1`"               *"
Write-Output "*  Or here:                                                                          *"
Write-Output "*    https://github.com/DarwinJS/ChocoPackages/blob/main/openssh/readme.md         *"
Write-Output "**************************************************************************************"
