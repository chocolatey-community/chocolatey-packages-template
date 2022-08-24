Write-Debug ("Starting " + $MyInvocation.MyCommand.Definition)

[string]$packageName="PowerShell.5.0"

<#
Exit Codes:
    3010: WSUSA executed the uninstall successfully.
    2359303: The update was not found.
#>

#5.0.10586
$osVersion = (Get-WmiObject Win32_OperatingSystem).Version
if(-not (($osVersion -ge [version]"6.4") -or ($osVersion -ge [version]"10.0"))) {
    Start-ChocolateyProcessAsAdmin "/uninstall /KB:3191566 /quiet /norestart /log:`"$env:TEMP\PowerShellUninstall5.evtx`"" -exeToRun "WUSA.exe" -validExitCodes @(3010,2359303)
    Start-ChocolateyProcessAsAdmin "/uninstall /KB:3191565 /quiet /norestart /log:`"$env:TEMP\PowerShellUninstall5.evtx`"" -exeToRun "WUSA.exe" -validExitCodes @(3010,2359303)
    Start-ChocolateyProcessAsAdmin "/uninstall /KB:3191564 /quiet /norestart /log:`"$env:TEMP\PowerShellUninstall5.evtx`"" -exeToRun "WUSA.exe" -validExitCodes @(3010,2359303)
}


Write-Warning "$packageName may require a reboot to complete the uninstallation."
