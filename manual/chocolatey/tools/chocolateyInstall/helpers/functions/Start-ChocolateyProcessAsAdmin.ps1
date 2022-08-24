# Copyright © 2017 - 2021 Chocolatey Software, Inc.
# Copyright © 2015 - 2017 RealDimensions Software, LLC
# Copyright © 2011 - 2015 RealDimensions Software, LLC & original authors/contributors from https://github.com/chocolatey/chocolatey
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function Start-ChocolateyProcessAsAdmin {
<#
.SYNOPSIS
**NOTE:** Administrative Access Required.

Runs a process with administrative privileges. If `-ExeToRun` is not
specified, it is run with PowerShell.

.NOTES
This command will assert UAC/Admin privileges on the machine.

Starting in 0.9.10, will automatically call Set-PowerShellExitCode to
set the package exit code in the following ways:

- 4 if the binary turns out to be a text file.
- The same exit code returned from the process that is run. If a 3010 is returned, it will set 3010 for the package.

Aliases `Start-ChocolateyProcess` and `Invoke-ChocolateyProcess`
available in 0.10.2+.

.INPUTS
None

.OUTPUTS
None

.PARAMETER Statements
Arguments to pass to `ExeToRun` or the PowerShell script block to be
run.

.PARAMETER ExeToRun
The executable/application/installer to run. Defaults to `'powershell'`.

.PARAMETER Elevated
Indicate whether the process should run elevated.

Available in 0.10.2+.

.PARAMETER Minimized
Switch indicating if a Windows pops up (if not called with a silent
argument) that it should be minimized.

.PARAMETER NoSleep
Used only when calling PowerShell - indicates the window that is opened
should return instantly when it is complete.

.PARAMETER ValidExitCodes
Array of exit codes indicating success. Defaults to `@(0)`.

.PARAMETER WorkingDirectory
The working directory for the running process. Defaults to
`Get-Location`. If current location is a UNC path, uses
`$env:TEMP` for default as of 0.10.14.

Available in 0.10.1+.

.PARAMETER SensitiveStatements
Arguments to pass to  `ExeToRun` that are not logged.

Note that only licensed versions of Chocolatey provide a way to pass
those values completely through without having them in the install
script or on the system in some way.

Available in 0.10.1+.

.PARAMETER IgnoredArguments
Allows splatting with arguments that do not apply. Do not use directly.

.EXAMPLE
Start-ChocolateyProcessAsAdmin -Statements "$msiArgs" -ExeToRun 'msiexec'

.EXAMPLE
Start-ChocolateyProcessAsAdmin -Statements "$silentArgs" -ExeToRun $file

.EXAMPLE
Start-ChocolateyProcessAsAdmin -Statements "$silentArgs" -ExeToRun $file -ValidExitCodes @(0,21)

.EXAMPLE
>
# Run PowerShell statements
$psFile = Join-Path "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" 'someInstall.ps1'
Start-ChocolateyProcessAsAdmin "& `'$psFile`'"

.EXAMPLE
# This also works for cmd and is required if you have any spaces in the paths within your command
$appPath = "$env:ProgramFiles\myapp"
$cmdBatch = "/c `"$appPath\bin\installmyappservice.bat`""
Start-ChocolateyProcessAsAdmin $cmdBatch cmd
# or more explicitly
Start-ChocolateyProcessAsAdmin -Statements $cmdBatch -ExeToRun "cmd.exe"

.LINK
Install-ChocolateyPackage

.LINK
Install-ChocolateyInstallPackage
#>
param(
  [parameter(Mandatory=$false, Position=0)][string[]] $statements,
  [parameter(Mandatory=$false, Position=1)][string] $exeToRun = 'powershell',
  [parameter(Mandatory=$false)][switch] $elevated = $true,
  [parameter(Mandatory=$false)][switch] $minimized,
  [parameter(Mandatory=$false)][switch] $noSleep,
  [parameter(Mandatory=$false)] $validExitCodes = @(0),
  [parameter(Mandatory=$false)][string] $workingDirectory = $null,
  [parameter(Mandatory=$false)][string] $sensitiveStatements = '',
  [parameter(ValueFromRemainingArguments = $true)][Object[]] $ignoredArguments
)
  [string]$statements = $statements -join ' '

  Write-FunctionCallLogMessage -Invocation $MyInvocation -Parameters $PSBoundParameters

  if ($workingDirectory -eq $null) {
    $pwd = $(Get-Location -PSProvider 'FileSystem')
    if ($pwd -eq $null -or $pwd.ProviderPath -eq $null) {
      Write-Debug "Unable to use current location for Working Directory. Using Cache Location instead."
      $workingDirectory = $env:TEMP
    }
    $workingDirectory = $pwd.ProviderPath
  }
  $alreadyElevated = $false
  if (Test-ProcessAdminRights) {
    $alreadyElevated = $true
  }

  $dbMessagePrepend = "Elevating permissions and running"
  if (!$elevated) {
    $dbMessagePrepend = "Running"
  }

  try {
    if ($exeToRun -ne $null) { $exeToRun = $exeToRun -replace "`0", "" }
    if ($statements -ne $null) { $statements = $statements -replace "`0", "" }
  } catch {
    Write-Debug "Removing null characters resulted in an error - $($_.Exception.Message)"
  }

  if ($exeToRun -ne $null) {
    $exeToRun = $exeToRun.Trim().Trim("'").Trim('"')
  }

  $wrappedStatements = $statements
  if ($wrappedStatements -eq $null) { $wrappedStatements = ''}

  if ($exeToRun -eq 'powershell') {
    $exeToRun = "$($env:SystemRoot)\System32\WindowsPowerShell\v1.0\powershell.exe"
    $importChocolateyHelpers = "& import-module -name '$helpersPath\chocolateyInstaller.psm1' -Verbose:`$false | Out-Null;"
    $block = @"
      `$noSleep = `$$noSleep
      #`$env:ChocolateyEnvironmentDebug='false'
      #`$env:ChocolateyEnvironmentVerbose='false'
      $importChocolateyHelpers
      try{
        `$progressPreference="SilentlyContinue"
        $statements
        if(!`$noSleep){start-sleep 6}
      }
      catch{
        if(!`$noSleep){start-sleep 8}
        throw
      }
"@
    $encoded = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($block))
    $wrappedStatements = "-NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -InputFormat Text -OutputFormat Text -EncodedCommand $encoded"
    $dbgMessage = @"
$dbMessagePrepend powershell block:
$block
This may take a while, depending on the statements.
"@

  }
  else
  {
    $dbgMessage = @"
$dbMessagePrepend [`"$exeToRun`" $wrappedStatements]. This may take a while, depending on the statements.
"@
  }

  Write-Debug $dbgMessage

  $exeIsTextFile = [System.IO.Path]::GetFullPath($exeToRun) + ".istext"
  if ([System.IO.File]::Exists($exeIsTextFile)) {
    Set-PowerShellExitCode 4
    throw "The file was a text file but is attempting to be run as an executable - '$exeToRun'"
  }

  if ($exeToRun -eq 'msiexec' -or $exeToRun -eq 'msiexec.exe') {
    $exeToRun = "$($env:SystemRoot)\System32\msiexec.exe"
  }

  if (!([System.IO.File]::Exists($exeToRun)) -and $exeToRun -notmatch 'msiexec') {
    Write-Warning "May not be able to find '$exeToRun'. Please use full path for executables."
    # until we have search paths enabled, let's just pass a warning
    #Set-PowerShellExitCode 2
    #throw "Could not find '$exeToRun'"
  }

  # Redirecting output slows things down a bit.
  $writeOutput = {
    if ($EventArgs.Data -ne $null) {
      Write-Verbose "$($EventArgs.Data)"
    }
  }

  $writeError = {
    if ($EventArgs.Data -ne $null) {
      Write-Error "$($EventArgs.Data)"
    }
  }

  $process = New-Object System.Diagnostics.Process
  $process.EnableRaisingEvents = $true
  Register-ObjectEvent -InputObject $process -SourceIdentifier "LogOutput_ChocolateyProc" -EventName OutputDataReceived -Action $writeOutput | Out-Null
  Register-ObjectEvent -InputObject $process -SourceIdentifier "LogErrors_ChocolateyProc" -EventName ErrorDataReceived -Action  $writeError | Out-Null

  #$process.StartInfo = New-Object System.Diagnostics.ProcessStartInfo($exeToRun, $wrappedStatements)
  # in case empty args makes a difference, try to be compatible with the older
  # version
  $psi = New-Object System.Diagnostics.ProcessStartInfo

  $psi.FileName = $exeToRun
  if ($wrappedStatements -ne '') {
    $psi.Arguments = "$wrappedStatements"
  }
  if ($sensitiveStatements -ne $null -and $sensitiveStatements -ne '') {
    Write-Host "Sensitive arguments have been passed. Adding to arguments."
    $psi.Arguments += " $sensitiveStatements"
  }
  $process.StartInfo =  $psi

  # process start info
  $process.StartInfo.RedirectStandardOutput = $true
  $process.StartInfo.RedirectStandardError = $true
  $process.StartInfo.UseShellExecute = $false
  $process.StartInfo.WorkingDirectory = $workingDirectory

  if ($elevated -and -not $alreadyElevated -and [Environment]::OSVersion.Version -ge (New-Object 'Version' 6,0)){
    # this doesn't actually currently work - because we are not running under shell execute
    Write-Debug "Setting RunAs for elevation"
    $process.StartInfo.Verb = "RunAs"
  }
  if ($minimized) {
    $process.StartInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Minimized
  }

  $process.Start() | Out-Null
  if ($process.StartInfo.RedirectStandardOutput) { $process.BeginOutputReadLine() }
  if ($process.StartInfo.RedirectStandardError) { $process.BeginErrorReadLine() }
  $process.WaitForExit()

  # For some reason this forces the jobs to finish and waits for
  # them to do so. Without this it never finishes.
  Unregister-Event -SourceIdentifier "LogOutput_ChocolateyProc"
  Unregister-Event -SourceIdentifier "LogErrors_ChocolateyProc"

  # sometimes the process hasn't fully exited yet.
  for ($loopCount=1; $loopCount -le 15; $loopCount++) {
    if ($process.HasExited) { break; }
    Write-Debug "Waiting for process to exit - $loopCount/15 seconds";
    Start-Sleep 1;
  }

  $exitCode = $process.ExitCode
  $process.Dispose()

  Write-Debug "Command [`"$exeToRun`" $wrappedStatements] exited with `'$exitCode`'."

  $exitErrorMessage = ''
  $errorMessageAddendum = " This is most likely an issue with the '$env:chocolateyPackageName' package and not with Chocolatey itself. Please follow up with the package maintainer(s) directly."

  switch ($exitCode) {
    0 { break }
    1 { break }
    3010 { break }
    # NSIS - http://nsis.sourceforge.net/Docs/AppendixD.html
    # InnoSetup - http://www.jrsoftware.org/ishelp/index.php?topic=setupexitcodes
    2 { $exitErrorMessage = 'Setup was cancelled.'; break }
    3 { $exitErrorMessage = 'A fatal error occurred when preparing or moving to next install phase. Check to be sure you have enough memory to perform an installation and try again.'; break }
    4 { $exitErrorMessage = 'A fatal error occurred during installation process.' + $errorMessageAddendum; break }
    5 { $exitErrorMessage = 'User (you) cancelled the installation.'; break }
    6 { $exitErrorMessage = 'Setup process was forcefully terminated by the debugger.'; break }
    7 { $exitErrorMessage = 'While preparing to install, it was determined setup cannot proceed with the installation. Please be sure the software can be installed on your system.'; break }
    8 { $exitErrorMessage = 'While preparing to install, it was determined setup cannot proceed with the installation until you restart the system. Please reboot and try again.'; break }
    # MSI - https://msdn.microsoft.com/en-us/library/windows/desktop/aa376931.aspx
    1602 { $exitErrorMessage = 'User (you) cancelled the installation.'; break }
    1603 { $exitErrorMessage = "Generic MSI Error. This is a local environment error, not an issue with a package or the MSI itself - it could mean a pending reboot is necessary prior to install or something else (like the same version is already installed). Please see MSI log if available. If not, try again adding `'--install-arguments=`"`'/l*v c:\$($env:chocolateyPackageName)_msi_install.log`'`"`'. Then search the MSI Log for `"Return Value 3`" and look above that for the error."; break }
    1618 { $exitErrorMessage = 'Another installation currently in progress. Try again later.'; break }
    1619 { $exitErrorMessage = 'MSI could not be found - it is possibly corrupt or not an MSI at all. If it was downloaded and the MSI is less than 30K, try opening it in an editor like Notepad++ as it is likely HTML.' + $errorMessageAddendum; break }
    1620 { $exitErrorMessage = 'MSI could not be opened - it is possibly corrupt or not an MSI at all. If it was downloaded and the MSI is less than 30K, try opening it in an editor like Notepad++ as it is likely HTML.' + $errorMessageAddendum; break }
    1622 { $exitErrorMessage = 'Something is wrong with the install log location specified. Please fix this in the package silent arguments (or in install arguments you specified). The directory specified as part of the log file path must exist for an MSI to be able to log to that directory.' + $errorMessageAddendum; break }
    1623 { $exitErrorMessage = 'This MSI has a language that is not supported by your system. Contact package maintainer(s) if there is an install available in your language and you would like it added to the packaging.'; break }
    1625 { $exitErrorMessage = 'Installation of this MSI is forbidden by system policy. Please contact your system administrators.'; break }
    1632 { $exitErrorMessage = 'Installation of this MSI is not supported on this platform. Contact package maintainer(s) if you feel this is in error or if you need an architecture that is not available with the current packaging.'; break }
    1633 { $exitErrorMessage = 'Installation of this MSI is not supported on this platform. Contact package maintainer(s) if you feel this is in error or if you need an architecture that is not available with the current packaging.'; break }
    1638 { $exitErrorMessage = 'This MSI requires uninstall prior to installing a different version. Please ask the package maintainer(s) to add a check in the chocolateyInstall.ps1 script and uninstall if the software is installed.' + $errorMessageAddendum; break }
    1639 { $exitErrorMessage = 'The command line arguments passed to the MSI are incorrect. If you passed in additional arguments, please adjust. Otherwise followup with the package maintainer(s) to get this fixed.' + $errorMessageAddendum; break }
    1640 { $exitErrorMessage = 'Cannot install MSI when running from remote desktop (terminal services). This should automatically be handled in licensed editions. For open source editions, you may need to run change.exe prior to running Chocolatey or not use terminal services.'; break }
    1645 { $exitErrorMessage = 'Cannot install MSI when running from remote desktop (terminal services). This should automatically be handled in licensed editions. For open source editions, you may need to run change.exe prior to running Chocolatey or not use terminal services.'; break }
  }

  if ($exitErrorMessage) {
    $errorMessageSpecific = "Exit code indicates the following: $exitErrorMessage."
    Write-Warning $exitErrorMessage
  } else {
    $errorMessageSpecific = 'See log for possible error messages.'
  }

  if ($validExitCodes -notcontains $exitCode) {
    Set-PowerShellExitCode $exitCode
    throw "Running [`"$exeToRun`" $wrappedStatements] was not successful. Exit code was '$exitCode'. $($errorMessageSpecific)"
  } else {
    $chocoSuccessCodes = @(0, 1605, 1614, 1641, 3010)
    if ($chocoSuccessCodes -notcontains $exitCode) {
      Write-Warning "Exit code '$exitCode' was considered valid by script, but not as a Chocolatey success code. Returning '0'."
      $exitCode = 0
    }
  }

  Write-Debug "Finishing '$($MyInvocation.InvocationName)'"

  return $exitCode
}

Set-Alias Start-ChocolateyProcess Start-ChocolateyProcessAsAdmin
Set-Alias Invoke-ChocolateyProcess Start-ChocolateyProcessAsAdmin

# SIG # Begin signature block
# MIIZvwYJKoZIhvcNAQcCoIIZsDCCGawCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAwKXYkKTO0i7XN
# czYNahL5klmQZ3d0XBusQK2SGbHGA6CCFKgwggT+MIID5qADAgECAhANQkrgvjqI
# /2BAIc4UAPDdMA0GCSqGSIb3DQEBCwUAMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNV
# BAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBUaW1lc3RhbXBpbmcgQ0EwHhcN
# MjEwMTAxMDAwMDAwWhcNMzEwMTA2MDAwMDAwWjBIMQswCQYDVQQGEwJVUzEXMBUG
# A1UEChMORGlnaUNlcnQsIEluYy4xIDAeBgNVBAMTF0RpZ2lDZXJ0IFRpbWVzdGFt
# cCAyMDIxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwuZhhGfFivUN
# CKRFymNrUdc6EUK9CnV1TZS0DFC1JhD+HchvkWsMlucaXEjvROW/m2HNFZFiWrj/
# ZwucY/02aoH6KfjdK3CF3gIY83htvH35x20JPb5qdofpir34hF0edsnkxnZ2OlPR
# 0dNaNo/Go+EvGzq3YdZz7E5tM4p8XUUtS7FQ5kE6N1aG3JMjjfdQJehk5t3Tjy9X
# tYcg6w6OLNUj2vRNeEbjA4MxKUpcDDGKSoyIxfcwWvkUrxVfbENJCf0mI1P2jWPo
# GqtbsR0wwptpgrTb/FZUvB+hh6u+elsKIC9LCcmVp42y+tZji06lchzun3oBc/gZ
# 1v4NSYS9AQIDAQABo4IBuDCCAbQwDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQC
# MAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwQQYDVR0gBDowODA2BglghkgBhv1s
# BwEwKTAnBggrBgEFBQcCARYbaHR0cDovL3d3dy5kaWdpY2VydC5jb20vQ1BTMB8G
# A1UdIwQYMBaAFPS24SAd/imu0uRhpbKiJbLIFzVuMB0GA1UdDgQWBBQ2RIaOpLqw
# Zr68KC0dRDbd42p6vDBxBgNVHR8EajBoMDKgMKAuhixodHRwOi8vY3JsMy5kaWdp
# Y2VydC5jb20vc2hhMi1hc3N1cmVkLXRzLmNybDAyoDCgLoYsaHR0cDovL2NybDQu
# ZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC10cy5jcmwwgYUGCCsGAQUFBwEBBHkw
# dzAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME8GCCsGAQUF
# BzAChkNodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEyQXNz
# dXJlZElEVGltZXN0YW1waW5nQ0EuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBIHNy1
# 6ZojvOca5yAOjmdG/UJyUXQKI0ejq5LSJcRwWb4UoOUngaVNFBUZB3nw0QTDhtk7
# vf5EAmZN7WmkD/a4cM9i6PVRSnh5Nnont/PnUp+Tp+1DnnvntN1BIon7h6JGA078
# 9P63ZHdjXyNSaYOC+hpT7ZDMjaEXcw3082U5cEvznNZ6e9oMvD0y0BvL9WH8dQgA
# dryBDvjA4VzPxBFy5xtkSdgimnUVQvUtMjiB2vRgorq0Uvtc4GEkJU+y38kpqHND
# Udq9Y9YfW5v3LhtPEx33Sg1xfpe39D+E68Hjo0mh+s6nv1bPull2YYlffqe0jmd4
# +TaY4cso2luHpoovMIIFMDCCBBigAwIBAgIQBAkYG1/Vu2Z1U0O1b5VQCDANBgkq
# hkiG9w0BAQsFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5j
# MRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBB
# c3N1cmVkIElEIFJvb3QgQ0EwHhcNMTMxMDIyMTIwMDAwWhcNMjgxMDIyMTIwMDAw
# WjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQL
# ExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3Vy
# ZWQgSUQgQ29kZSBTaWduaW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
# CgKCAQEA+NOzHH8OEa9ndwfTCzFJGc/Q+0WZsTrbRPV/5aid2zLXcep2nQUut4/6
# kkPApfmJ1DcZ17aq8JyGpdglrA55KDp+6dFn08b7KSfH03sjlOSRI5aQd4L5oYQj
# ZhJUM1B0sSgmuyRpwsJS8hRniolF1C2ho+mILCCVrhxKhwjfDPXiTWAYvqrEsq5w
# MWYzcT6scKKrzn/pfMuSoeU7MRzP6vIK5Fe7SrXpdOYr/mzLfnQ5Ng2Q7+S1TqSp
# 6moKq4TzrGdOtcT3jNEgJSPrCGQ+UpbB8g8S9MWOD8Gi6CxR93O8vYWxYoNzQYIH
# 5DiLanMg0A9kczyen6Yzqf0Z3yWT0QIDAQABo4IBzTCCAckwEgYDVR0TAQH/BAgw
# BgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0lBAwwCgYIKwYBBQUHAwMweQYI
# KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
# b20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwgYEGA1UdHwR6MHgwOqA4oDaGNGh0dHA6
# Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmww
# OqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJ
# RFJvb3RDQS5jcmwwTwYDVR0gBEgwRjA4BgpghkgBhv1sAAIEMCowKAYIKwYBBQUH
# AgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCgYIYIZIAYb9bAMwHQYD
# VR0OBBYEFFrEuXsqCqOl6nEDwGD5LfZldQ5YMB8GA1UdIwQYMBaAFEXroq/0ksuC
# MS1Ri6enIZ3zbcgPMA0GCSqGSIb3DQEBCwUAA4IBAQA+7A1aJLPzItEVyCx8JSl2
# qB1dHC06GsTvMGHXfgtg/cM9D8Svi/3vKt8gVTew4fbRknUPUbRupY5a4l4kgU4Q
# pO4/cY5jDhNLrddfRHnzNhQGivecRk5c/5CxGwcOkRX7uq+1UcKNJK4kxscnKqEp
# KBo6cSgCPC6Ro8AlEeKcFEehemhor5unXCBc2XGxDI+7qPjFEmifz0DLQESlE/Dm
# ZAwlCEIysjaKJAL+L3J+HNdJRZboWR3p+nRka7LrZkPas7CM1ekN3fYBIM6ZMWM9
# CBoYs4GbT8aTEAb8B4H6i9r5gkn3Ym6hU/oSlBiFLpKR6mhsRDKyZqHnGKSaZFHv
# MIIFMTCCBBmgAwIBAgIQCqEl1tYyG35B5AXaNpfCFTANBgkqhkiG9w0BAQsFADBl
# MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
# d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJv
# b3QgQ0EwHhcNMTYwMTA3MTIwMDAwWhcNMzEwMTA3MTIwMDAwWjByMQswCQYDVQQG
# EwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNl
# cnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0
# YW1waW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvdAy7kvN
# j3/dqbqCmcU5VChXtiNKxA4HRTNREH3Q+X1NaH7ntqD0jbOI5Je/YyGQmL8TvFfT
# w+F+CNZqFAA49y4eO+7MpvYyWf5fZT/gm+vjRkcGGlV+Cyd+wKL1oODeIj8O/36V
# +/OjuiI+GKwR5PCZA207hXwJ0+5dyJoLVOOoCXFr4M8iEA91z3FyTgqt30A6XLdR
# 4aF5FMZNJCMwXbzsPGBqrC8HzP3w6kfZiFBe/WZuVmEnKYmEUeaC50ZQ/ZQqLKfk
# dT66mA+Ef58xFNat1fJky3seBdCEGXIX8RcG7z3N1k3vBkL9olMqT4UdxB08r8/a
# rBD13ays6Vb/kwIDAQABo4IBzjCCAcowHQYDVR0OBBYEFPS24SAd/imu0uRhpbKi
# JbLIFzVuMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMBIGA1UdEwEB
# /wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMI
# MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNl
# cnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
# RGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MIGBBgNVHR8EejB4MDqgOKA2hjRo
# dHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0Eu
# Y3JsMDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
# cmVkSURSb290Q0EuY3JsMFAGA1UdIARJMEcwOAYKYIZIAYb9bAACBDAqMCgGCCsG
# AQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAsGCWCGSAGG/WwH
# ATANBgkqhkiG9w0BAQsFAAOCAQEAcZUS6VGHVmnN793afKpjerN4zwY3QITvS4S/
# ys8DAv3Fp8MOIEIsr3fzKx8MIVoqtwU0HWqumfgnoma/Capg33akOpMP+LLR2HwZ
# YuhegiUexLoceywh4tZbLBQ1QwRostt1AuByx5jWPGTlH0gQGF+JOGFNYkYkh2OM
# kVIsrymJ5Xgf1gsUpYDXEkdws3XVk4WTfraSZ/tTYYmo9WuWwPRYaQ18yAGxuSh1
# t5ljhSKMYcp5lH5Z/IwP42+1ASa2bKXuh1Eh5Fhgm7oMLSttosR+u8QlK0cCCHxJ
# rhO24XxCQijGGFbPQTS2Zl22dHv1VjMiLyI2skuiSpXY9aaOUjCCBTkwggQhoAMC
# AQICEAq50xD7ISvojIGz0sLozlEwDQYJKoZIhvcNAQELBQAwcjELMAkGA1UEBhMC
# VVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0
# LmNvbTExMC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIENvZGUgU2ln
# bmluZyBDQTAeFw0yMTA0MjcwMDAwMDBaFw0yNDA0MzAyMzU5NTlaMHcxCzAJBgNV
# BAYTAlVTMQ8wDQYDVQQIEwZLYW5zYXMxDzANBgNVBAcTBlRvcGVrYTEiMCAGA1UE
# ChMZQ2hvY29sYXRleSBTb2Z0d2FyZSwgSW5jLjEiMCAGA1UEAxMZQ2hvY29sYXRl
# eSBTb2Z0d2FyZSwgSW5jLjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
# AKFxp42p47c7eHNsNhgxzG+/9A1I8Th+kj40YQJH4Vh0M7a61f39I/FELNYGuyCe
# 0+z/sg+T+4VmT/JMiI2hc75yokTjkv3Yt1+fqABzCMadr+PZ/9ttIVJ5db3P2Uzc
# Ml5wXBdCV5ZH/w4oKcP53VmYcHQEDm/RtAJ9TxlPtLS734oAqrKqBmsnJCI98FWp
# d6z1FK5rv7RJVeZoGsl/2eMcB/ko0Vj9MSCbWvXNjDF9yy4Tl5h2vb+y7K1Qmk3X
# yb0OYB1ibva9rQozGgogEa5DL0OdoMj6cyJ6Cx2GQv2wjKwiKfs9zCOTDH2VGa0i
# okDbsd+BvUxovQ6eSnBFj5UCAwEAAaOCAcQwggHAMB8GA1UdIwQYMBaAFFrEuXsq
# CqOl6nEDwGD5LfZldQ5YMB0GA1UdDgQWBBRO8wUYXZXrKVBqUW35p9FeNJoEgzAO
# BgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwdwYDVR0fBHAwbjA1
# oDOgMYYvaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC1jcy1n
# MS5jcmwwNaAzoDGGL2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3Vy
# ZWQtY3MtZzEuY3JsMEsGA1UdIAREMEIwNgYJYIZIAYb9bAMBMCkwJwYIKwYBBQUH
# AgEWG2h0dHA6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAIBgZngQwBBAEwgYQGCCsG
# AQUFBwEBBHgwdjAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
# ME4GCCsGAQUFBzAChkJodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRTSEEyQXNzdXJlZElEQ29kZVNpZ25pbmdDQS5jcnQwDAYDVR0TAQH/BAIwADAN
# BgkqhkiG9w0BAQsFAAOCAQEAoXGdwcDMMV6xQldozbWoxGTn6chlwO4hJ8aAlwOM
# wexEvDudrlifsiGI1j46wqc9WR8+Ev8w1dIcbqif4inGIHb8GvL22Goq+lB08F7y
# YU3Ry0kOCtJx7JELlID0SI7bYndg17TJUQoAb5iTYD9aEoHMIKlGyQyVGvsp4ubo
# O8CC8Owx+Qq148yXY+to4360U2lzZvUtMpPiiSJTm4BamNgC32xgGwpN5lvk0m3R
# lDdqQQQgBCzrf+ZIMBmXMw4kxY0r/K/g1TkKI9VyiEnRaNQlQisAyYBWVnaHw2EJ
# ck6/bxwdYSA+Sz/Op0N0iEl8MX4At3XQlMGvAI1xhAbrwDGCBG0wggRpAgEBMIGG
# MHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsT
# EHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJl
# ZCBJRCBDb2RlIFNpZ25pbmcgQ0ECEAq50xD7ISvojIGz0sLozlEwDQYJYIZIAWUD
# BAIBBQCggYQwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMx
# DAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkq
# hkiG9w0BCQQxIgQg+S9AHNnTl0J/f0v7bSz1OM9T3EeyztXJn5U7fYJlfvswDQYJ
# KoZIhvcNAQEBBQAEggEAUKZ+5F8yVXqZhnyTJIi7ZnHeN/LkTpCYZ9PY1fyirWFS
# 7nfje02kynXjP+7hTh8OaAQ/C/DNPpuiHBqa3jq8yVZz/x7kmx2X2GsuymX1SVrz
# vi12T1C7JjIPQ/xQ6nw1VzehIRsKvcv1XhTIuRjyaBfARjWfPVkFL94D6XH7L9s8
# R3E2m+E0nLoHv1dyFix9b0vyAuuF7TjTIpy0ZlJiCdczi4Lk8f3wWTFn1xvlxF3C
# S83MDadkcHCxsLQZtMyWpmOEw3qcysuvJFEAODhBZRrsEtYWVSewQY+Afm7HsnWh
# GX9/MOWFDSfoMWD+L85zzHgLWwtaOhE+kgaWxGL/DaGCAjAwggIsBgkqhkiG9w0B
# CQYxggIdMIICGQIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNl
# cnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdp
# Q2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBAhANQkrgvjqI/2BA
# Ic4UAPDdMA0GCWCGSAFlAwQCAQUAoGkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
# ATAcBgkqhkiG9w0BCQUxDxcNMjIwMzMwMDc1MTU2WjAvBgkqhkiG9w0BCQQxIgQg
# Uwy6qdSNOJ3A1vWC7a43td3hmH30+R30e5EXUkoVsDAwDQYJKoZIhvcNAQEBBQAE
# ggEAsDNFgRwl81dzNbgPhPPzqrBU39CJ3KaPDWhp2ow1bmQ85WjaQJiymR8VYnfN
# 7mM9H651ZSJtIcg8xRn2DrZ+KKed5DiITQpYd19vzPfRoDYfaBcN5DhPVhwJeDii
# AOZbl7HUb7a4rqIQHJm1ZptaZvyiLfuuMmg9/6Iy2au7GsJFTDjmT9UBpWCGqcWS
# IzkQGnQlkg3HM4EWyYz14KTSbkFQQsqUBtfYwS10HE3Mv/FM1txAKpf8Vlf4cYsZ
# 2nLIJ7R9QI4xSbd9t5husNevN6GCDOTLgGmRcMBsreLRLIlxfxoKYO9kOt7LDNOS
# +XmEd7IlbJGUNI15W8pJ6zmdbQ==
# SIG # End signature block
