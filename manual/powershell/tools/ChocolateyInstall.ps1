<#
See http://technet.microsoft.com/en-us/library/hh847769.aspx and http://technet.microsoft.com/en-us/library/hh847837.aspx
Windows PowerShell 5.0 runs on the following versions of Windows.
	Windows 10, installed by default
	Windows Server 2012 R2, install Windows Management Framework 5.0 to run Windows PowerShell 5.0
	Windows 8.1, install Windows Management Framework 5.0 to run Windows PowerShell 5.0
	Windows 7 with Service Pack 1, install Windows Management Framework 4.0 and THEN WMF 5.0 (as of 5.0.10105)
	Windows Server 2008 R2 with Service Pack 1, install Windows Management Framework 5.0 (as of 5.0.10105)
	Previous Windows versions - 5.0 is not supported.

Windows PowerShell 4.0 runs on the following versions of Windows.
	Windows 8.1, installed by default
	Windows Server 2012 R2, installed by default
	Windows 7 with Service Pack 1, install Windows Management Framework 4.0 (http://go.microsoft.com/fwlink/?LinkId=293881) to run Windows PowerShell 4.0
	Windows Server 2008 R2 with Service Pack 1, install Windows Management Framework 4.0 (http://go.microsoft.com/fwlink/?LinkId=293881) to run Windows PowerShell 4.0

Windows PowerShell 3.0 runs on the following versions of Windows.
	Windows 8, installed by default
	Windows Server 2012, installed by default
	Windows 7 with Service Pack 1, install Windows Management Framework 3.0 to run Windows PowerShell 3.0
	Windows Server 2008 R2 with Service Pack 1, install Windows Management Framework 3.0 to run Windows PowerShell 3.0
	Windows Server 2008 with Service Pack 2, install Windows Management Framework 3.0 to run Windows PowerShell 3.0
#>

[string]$packageName="PowerShell"
[string]$installerType="msu"
[string]$installlogfilename = "$env:TEMP\PowerShell-Install-$(Get-date -format 'yyyyMMddhhmm').evtx"
[string]$ThisPackagePSHVersion = '5.1.14409.1005'
[string]$silentArgs="/quiet /norestart /log:`"$installlogfilename`""
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

[string]$urlWin81x86   =                 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1-KB3191564-x86.msu'
[string]$urlWin81x86checksum   =         'F3430A90BE556A77A30BAB3AC36DC9B92A43055D5FCC5869DA3BFDA116DBD817'
[string]$urlWin2k12R2andWin81x64 =       'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1AndW2K12R2-KB3191564-x64.msu'
[string]$urlWin2k12R2andWin81x64checksum = 'A8D788FA31B02A999CC676FB546FC782E86C2A0ACD837976122A1891CEEE42C0'
[string]$urlWin7x86   =                  'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7-KB3191566-x86.zip'
[string]$urlWin7x86checksum   =          'EB7E2C4CE2C6CB24206474A6CB8610D9F4BD3A9301F1CD8963B4FF64E529F563'
[string]$urlWin2k8R2andWin7x64 =         'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip'
[string]$urlWin2k8R2andWin7x64checksum = 'F383C34AA65332662A17D95409A2DDEDADCEDA74427E35D05024CD0A6A2FA647'
[string]$urlWin2012 =                    'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/W2K12-KB3191565-x64.msu'
[string]$urlWin2012checksum =            '4A1385642C1F08E3BE7BC70F4A9D74954E239317F50D1A7F60AA444D759D4F49'
[string]$ChecksumType       =            'sha256'

[string[]] $validExitCodes = @(0, 3010) # 2359302 occurs if the package is already installed

$osversionLookup = @{
"5.1.2600" = "XP";
"5.1.3790" = "2003";
"6.0.6001" = "Vista/2008";
"6.1.7600" = "Win7/2008R2";
"6.1.7601" = "Win7 SP1/2008R2 SP1"; # SP1 or later.
"6.2.9200" = "Win8/2012";
"6.3.9600" = "Win8.1/2012R2";
"10.0.*" = "Windows 10/Server 2016"
}

function Install-PowerShell5([string]$urlx86, [string]$urlx64 = $null, [string]$checksumx86 = $null,[string]$checksumx64 = $null) {
    $MinimumNet4Version = 378389
    $Net4Version = (get-itemproperty "hklm:software\microsoft\net framework setup\ndp\v4\full" -ea silentlycontinue | Select -Expand Release -ea silentlycontinue)
    if ($Net4Version -ge $MinimumNet4Version) {
        Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" -url $urlx86 -url64 $urlx64 -checksum $checksumx86 -ChecksumType $ChecksumType -checksum64 $checksumx64 -ChecksumType64 $ChecksumType -validExitCodes $validExitCodes
        Write-Warning "$packageName requires a reboot to complete the installation."
    }
    else {
        throw ".NET Framework 4.5.2 or later required.  Use package named `"dotnet4.5` to upgrade.  Your .NET Release is `"$Net4Version`" but needs to be at least `"$MinimumNet4Version`"."
    }
}

$os = Get-WmiObject Win32_OperatingSystem
$osVersion = $os.version

$ProductName = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'ProductName').ProductName
$EditionId = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'EditionID').EditionId

#This will show us if we are running on Nano Server (Kernel version alone won't show this)
Write-Output "Running on: $ProductName, ($EditionId), Windows Kernel: $osVersion"

If ((get-service wuauserv).starttype -ieq 'Disabled')
{
  Throw "Windows Update Service is disabled - PowerShell updates are distributed as windows updates and so require the service.  Consider temporarily enabling it before calling this package and disabling again afterward."
}

try
{
    if ($PSVersionTable -and ($PSVersionTable.PSVersion -ge [Version]$ThisPackagePSHVersion)) {
	    Write-Warning "PowerShell version, $($PSVersionTable.PSVersion), is already installed."
	}
    else {
        #The following should not occur as PowerShell 5 is already installed
        if( ([version]$osVersion).Major -eq "10" ) {
            $osVersion = "$(([version]$osVersion).Major).$(([version]$osVersion).Minor).*"
        }

        Write-Output "Installing for OS: $($osversionLookup[$osVersion])"

		    switch ($osversionLookup[$osVersion]) {
            "Vista/2008" {
                Write-Warning "PowerShell 3 is the highest supported on Windows $($osversionLookup[$osVersion])."
                Write-Output "You can install PowerShell 3 using these parameters: 'PowerShell -version 3.0.20121027'"
            }
            "Win7/2008R2" {
                Write-Warning "PowerShell $ThisPackagePSHVersion Requires SP1 for Windows $($osversionLookup[$osVersion])."
                Write-Warning "Update to SP1 and re-run this package to install WMF/PowerShell 5"
                Write-Output "You can install PowerShell 3 using these parameters: 'PowerShell -version 3.0.20121027'"
            }
            "Win7 SP1/2008R2 SP1" {
                #Special Procedures for WMF 5.1
                $MinimumNet4Version = 378389
                $Net4Version = (get-itemproperty "hklm:software\microsoft\net framework setup\ndp\v4\full" -ea silentlycontinue | Select -Expand Release -ea silentlycontinue)
                if ($Net4Version -lt $MinimumNet4Version)
                {
                  throw ".NET Framework 4.5.2 or later required.  Use package named `"dotnet4.5` to upgrade.  Your .NET Release is `"$MinimumNet4Version`" but needs to be at least `"$MinimumNet4Version`"."
                }
                Else
                {
                  If ($PSVersionTable.PSVersion.Major -eq 3)
                  {
                    Write-Warning "Found WMF 3 On Win 7 or Server 2008 R2"
                    If (!(test-path env:ChocolateyForce))
                    {
                        Throw "This package will not install WMF 5.1 over 3.0 on Windows 7 or Server 2008 R2 Unless you use the -Force switch on the package command line."
                    }
                    Else
                    {
                        Write-Host " " 
                        Write-Host "  ***********************************************************************************************"
                        Write-Host "  *  This machine is running Windows or Server 2008 R2 with WMF 3 installed and                 *"
                        Write-Host "  *  -Force was used, Experimental PSModulePath Backup and Attempted Restore Will Be Performed  *"
                        Write-Host "  *     What will be done:                                                                      *"
                        Write-Host "  *       1) The custom parts of the PSModulePath backed up to BackupPSModulePath               *"
                        Write-Host "  *       2) A fix up script that appends those values to the PSModulePath is written to:       *"
                        Write-Host "  *             %WINDIR%\Temp\psmodulepathfixup.ps1                                             *"
                        Write-Host "  *       3) A scheduled task is setup for the next reboot that runs the fix up script          *"
                        Write-Host "  *                                                                                             *"
                        Write-Host "  *   If you find that #3 does not work correctly, then you can use #1 or #2 with some of your  *"
                        Write-Host "  *   own automation to recover from the situation                                              *"
                        Write-Host "  ***********************************************************************************************"
                        Write-Host " " 
                        
                        $StandardPathsToFilterOut = @('%ProgramFiles%\WindowsPowerShell\Modules','%SystemRoot%\System32\WindowsPowerShell\v1.0\Modules','%SystemRoot%\System32\WindowsPowerShell\v1.0\Modules\')
                        [string[]]$currentpsmodulepath = (get-Item 'hklm:system\CurrentControlSet\Control\Session Manager\Environment').GetValue("PsModulePath","Default",[Microsoft.WIN32.RegistryValueOptions]::DoNotExpandEnvironmentNames).split(';')
                        $FilteredList = ($CurrentPSModulePath | Where {$StandardPathsToFilterOut -inotcontains $_}) -join ';'
                        Write-host "PSModulePath contains the following values that are not in the PSH 5 default values: $FilteredList, backing them up to BackupPSModulePath Environment Variable"
                        If ($FilteredList) {New-Itemproperty 'hklm:system\CurrentControlSet\Control\Session Manager\Environment' -name 'BackupPsModulePath' -PropertyType 'ExpandString' -value "$FilteredList" | out-null}
                        $WMF5Over3WasForced = $True
                    }
                  }
                  Install-ChocolateyZipPackage -PackageName "$packagename" -unziplocation "$toolsdir" -url "$urlWin7x86" -checksum "$urlWin7x86checksum" -checksumtype "$ChecksumType" -url64bit "$urlWin2k8R2andWin7x64" -checksum64 "$urlWin2k8R2andWin7x64checksum" -checksumtype64 "$ChecksumType"
                  $x64MSUName = "$toolsdir\$(($urlWin2k8R2andWin7x64.split('/') | select -last 1).replace('.zip','.msu'))"
                  $x86MSUName = "$toolsdir\$(($urlwin7x86.split('/') | select -last 1).replace('.zip','.msu'))"
                  Write-Host "64-bit file: $x64MSUName"
                      Install-ChocolateyPackage "$packageName" 'MSU' "$SilentArgs" -url $x86MSUName -url64 $x64MSUName -validExitCodes $validExitCodes
                  If ($WMF5Over3WasForced)
                  {
                    If (!$FilteredList)
                    {
                        Write-Host "PSModulePath does not contain any customized paths that need to be preserved."
                    }
                    Else
                    {
                        $scriptlocation = "$env:windir\temp\psmodulepathfixup.ps1"

                        $code = "set-Itemproperty 'hklm:system\CurrentControlSet\Control\Session Manager\Environment' -name 'PsModulePath' -value `$((get-Item 'hklm:system\CurrentControlSet\Control\Session Manager\Environment').GetValue('PsModulePath','Default',[Microsoft.WIN32.RegistryValueOptions]::DoNotExpandEnvironmentNames)" + "+`';$(invoke-expression -command '(get-variable FilteredList).value')`'" + ')'
                        $code | out-file $scriptlocation
                        "start-sleep -s 2" | out-file $scriptlocation -append
                        "schtasks.exe /delete /f /tn `"PSModulePathFixUp`"" | out-file $scriptlocation -append

                        schtasks.exe /create /tn "PSModulePathFixUp" /ru SYSTEM /Sc ONSTART /tr "powershell.exe -file $scriptlocation"

                        Write-Host "`"$scriptlocation`" is scheduled to run on reboot."

                        Write-Warning "ATTENTION: This Computer Must Be Restarted."
                    }
                  }
                }
            }
            "Win8/2012" {
                if($os.ProductType -gt 1) {
                    #Windows 2012
                    Install-PowerShell5 -urlx86 "$urlWin2012" -checksumx86 $urlWin2012checksum
                }
                else {
                    #Windows 8
                    Write-Verbose "Windows 8 (not 8.1) is not supported"
                    throw "$packageName not supported on Windows 8. You must upgrade to Windows 8.1 to install WMF/PowerShell 5.0."
                }
            }
            "Win8.1/2012R2" {
              Install-PowerShell5 -urlx86 "$urlWin81x86" -checksumx86 $urlWin81x86checksum -urlx64 "$urlWin2k12R2andWin81x64" -checksumx64 $urlWin2k12R2andWin81x64checksum -checksumtype "$ChecksumType" -checksumtype64 "$ChecksumType"
            }
            "Windows 10/Server 2016" {
                #Should never be reached.
                Write-Warning "Windows 10 / Server 2016 has WMF/PowerShell 5 pre-installed which is maintained by Windows Updates."
            }
            default {
                # Windows XP, Windows 2003, Windows Vista, or unknown?
                throw "$packageName $ThisPackagePSHVersion is not supported on $ProductName, ($EditionId), Windows Kernel: $osVersion"
            }
	    }
    }
}
catch {
  If (Test-Path "$installlogfilename")
  {
    Write-Host "Opps we had a error."
    $logfileerrors = @(Get-WinEvent -Path "$installlogfilename" -oldest | where {($_.level -ge 2) -AND ($_.level -le 3)})
    If ($logfileerrors.count -gt 0)
    {
      Write-Host "Found the following error(s) and warnings in the MSU log `"$installlogfilename`""
      $logfileerrors | Format-List ID, Message | out-string | write-host
    }
  }
  Throw $_.Exception
}
