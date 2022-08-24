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

function Get-ChocolateyUnzip {
<#
.SYNOPSIS
Unzips an archive file and returns the location for further processing.

.DESCRIPTION
This unzips files using the 7-zip command line tool 7z.exe.
Supported archive formats are listed at:
https://sevenzip.osdn.jp/chm/general/formats.htm
Prior to 0.9.10.1, 7za.exe was used. Supported archive formats for
7za.exe are: 7z, lzma, cab, zip, gzip, bzip2, and tar.

.INPUTS
None

.OUTPUTS
Returns the passed in $destination.

.NOTES
If extraction fails, an exception is thrown.

If you are embedding files into a package, ensure that you have the
rights to redistribute those files if you are sharing this package
publicly (like on the community feed). Otherwise, please use
Install-ChocolateyZipPackage to download those resources from their
official distribution points.

Starting in 0.9.10, will automatically call Set-PowerShellExitCode to
set the package exit code based on 7-zip's exit code.

.PARAMETER FileFullPath
This is the full path to the zip file. If embedding it in the package
next to the install script, the path will be like
`"$(Split-Path -Parent $MyInvocation.MyCommand.Definition)\\file.zip"`

In 0.10.1+, `File` is an alias for FileFullPath.

This can be a 32-bit or 64-bit file. This is mandatory in earlier versions
of Chocolatey, but optional if FileFullPath64 has been provided.

.PARAMETER FileFullPath64
Full file path to a 64-bit native installer to run. Available in 0.10.4+.
If embedding in the package, you can get it to the path with
`"$(Split-Path -parent $MyInvocation.MyCommand.Definition)\\INSTALLER_FILE"`

Provide this when you want to provide both 32-bit and 64-bit
installers or explicitly only a 64-bit installer (which will cause a package
install failure on 32-bit systems).

.PARAMETER Destination
This is a directory where you would like the unzipped files to end up.
If it does not exist, it will be created.

.PARAMETER SpecificFolder
OPTIONAL - This is a specific directory within zip file to extract. The
folder and its contents will be extracted to the destination.

.PARAMETER PackageName
OPTIONAL - This will facilitate logging unzip activity for subsequent
uninstalls

.PARAMETER IgnoredArguments
Allows splatting with arguments that do not apply. Do not use directly.

.EXAMPLE
>
# Path to the folder where the script is executing
$toolsDir = (Split-Path -parent $MyInvocation.MyCommand.Definition)
Get-ChocolateyUnzip -FileFullPath "c:\someFile.zip" -Destination $toolsDir

.LINK
Install-ChocolateyZipPackage
#>
param(
  [alias("file")][parameter(Mandatory=$false, Position=0)][string] $fileFullPath,
  [alias("unzipLocation")][parameter(Mandatory=$true, Position=1)][string] $destination,
  [parameter(Mandatory=$false, Position=2)][string] $specificFolder,
  [parameter(Mandatory=$false, Position=3)][string] $packageName,
  [alias("file64")][parameter(Mandatory=$false)][string] $fileFullPath64,
  [parameter(ValueFromRemainingArguments = $true)][Object[]] $ignoredArguments
)

  Write-FunctionCallLogMessage -Invocation $MyInvocation -Parameters $PSBoundParameters

   $bitnessMessage = ''
    $zipfileFullPath=$fileFullPath
  if ((Get-ProcessorBits 32) -or $env:ChocolateyForceX86 -eq 'true') {
    if (!$fileFullPath) { throw "32-bit archive is not supported for $packageName"; }
    if ($fileFullPath64) { $bitnessMessage = '32-bit '; }
  } elseif ($fileFullPath64) {
    $zipfileFullPath = $fileFullPath64
    $bitnessMessage = '64-bit '
  }

  if ($zipfileFullPath -eq '' -or $zipfileFullPath -eq $null) {
    throw 'Package parameters incorrect, either FileFullPath or FileFullPath64 must be specified.'
  }

  if ($packageName) {
    $packagelibPath = $env:ChocolateyPackageFolder
    if (!(Test-Path -path $packagelibPath)) {
      New-Item $packagelibPath -type directory
    }

    $zipFilename=split-path $zipfileFullPath -Leaf
    $zipExtractLogFullPath= Join-Path $packagelibPath $zipFilename`.txt
  }

  if ($env:chocolateyPackageName -ne $null -and $env:chocolateyPackageName -eq $env:ChocolateyInstallDirectoryPackage) {
    Write-Warning "Install Directory override not available for zip packages at this time.`n If this package also runs a native installer using Chocolatey`n functions, the directory will be honored."
  }

  Write-Host "Extracting $bitnessMessage$zipfileFullPath to $destination..."
  if (![System.IO.Directory]::Exists($destination)) { [System.IO.Directory]::CreateDirectory($destination) | Out-Null }

  $7zip = Join-Path "$helpersPath" '..\tools\7z.exe'
  if (!([System.IO.File]::Exists($7zip))) {
    Update-SessionEnvironment
    $7zip = Join-Path "$env:ChocolateyInstall" 'tools\7z.exe'
  }
  $7zip = [System.IO.Path]::GetFullPath($7zip)
  Write-Debug "7zip found at `'$7zip`'"

  # 32-bit 7z would not find C:\Windows\System32\config\systemprofile\AppData\Local\Temp,
  # because it gets translated to C:\Windows\SysWOW64\... by the WOW redirection layer.
  # Replace System32 with sysnative, which does not get redirected.
  # 32-bit 7z is required so it can see both architectures
  if ([IntPtr]::Size -ne 4) {
    $fileFullPathNoRedirection = $zipfileFullPath -ireplace ([System.Text.RegularExpressions.Regex]::Escape([Environment]::GetFolderPath('System'))),(Join-Path $Env:SystemRoot 'SysNative')
    $destinationNoRedirection = $destination -ireplace ([System.Text.RegularExpressions.Regex]::Escape([Environment]::GetFolderPath('System'))),(Join-Path $Env:SystemRoot 'SysNative')
  } else {
    $fileFullPathNoRedirection = $zipfileFullPath
    $destinationNoRedirection = $destination
  }

  $workingDirectory = $(Get-Location -PSProvider 'FileSystem')
  if ($workingDirectory -eq $null -or $workingDirectory.ProviderPath -eq $null) {
    Write-Debug "Unable to use current location for Working Directory. Using Cache Location instead."
    $workingDirectory = $env:TEMP
  }
  $workingDirectory = $workingDirectory.ProviderPath

  $params = "x -aoa -bd -bb1 -o`"$destinationNoRedirection`" -y `"$fileFullPathNoRedirection`""
  if ($specificfolder) {
    $params += " `"$specificfolder`""
  }
  Write-Debug "Executing command ['$7zip' $params]"

  # Capture 7z's output into a StringBuilder and write it out in blocks, to improve I/O performance.
  $global:zipFileList = New-Object System.Text.StringBuilder
  $global:zipDestinationFolder = $destination

  # Redirecting output slows things down a bit.
  $writeOutput = {
    if ($EventArgs.Data -ne $null) {
      $line = $EventArgs.Data
      Write-Verbose "$line"
      if ($line.StartsWith("- ")) {
        $global:zipFileList.AppendLine($global:zipDestinationFolder + "\" + $line.Substring(2))
      }
    }
  }

  $writeError = {
    if ($EventArgs.Data -ne $null) {
      Write-Error "$($EventArgs.Data)"
    }
  }

  $process = New-Object System.Diagnostics.Process
  $process.EnableRaisingEvents = $true
  Register-ObjectEvent -InputObject $process -SourceIdentifier "LogOutput_ChocolateyZipProc" -EventName OutputDataReceived -Action $writeOutput | Out-Null
  Register-ObjectEvent -InputObject $process -SourceIdentifier "LogErrors_ChocolateyZipProc" -EventName ErrorDataReceived -Action  $writeError | Out-Null

  $process.StartInfo = new-object System.Diagnostics.ProcessStartInfo($7zip, $params)
  $process.StartInfo.RedirectStandardOutput = $true
  $process.StartInfo.RedirectStandardError = $true
  $process.StartInfo.UseShellExecute = $false
  $process.StartInfo.WorkingDirectory = $workingDirectory
  $process.StartInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
  $process.StartInfo.CreateNoWindow = $true

  $process.Start() | Out-Null
  if ($process.StartInfo.RedirectStandardOutput) { $process.BeginOutputReadLine() }
  if ($process.StartInfo.RedirectStandardError) { $process.BeginErrorReadLine() }
  $process.WaitForExit()

  # For some reason this forces the jobs to finish and waits for
  # them to do so. Without this it never finishes.
  Unregister-Event -SourceIdentifier "LogOutput_ChocolateyZipProc"
  Unregister-Event -SourceIdentifier "LogErrors_ChocolateyZipProc"

  # sometimes the process hasn't fully exited yet.
  for ($loopCount=1; $loopCount -le 15; $loopCount++) {
    if ($process.HasExited) { break; }
    Write-Debug "Waiting for 7z.exe process to exit - $loopCount/15 seconds";
    Start-Sleep 1;
  }

  $exitCode = $process.ExitCode
  $process.Dispose()

  Set-PowerShellExitCode $exitCode
  Write-Debug "Command ['$7zip' $params] exited with `'$exitCode`'."

  if ($zipExtractLogFullPath) {
    Set-Content $zipExtractLogFullPath $global:zipFileList.ToString() -Encoding UTF8 -Force
  }

  Write-Debug "7z exit code: $exitCode"

  $errorMessageAddendum = " This is most likely an issue with the '$env:chocolateyPackageName' package and not with Chocolatey itself. Please follow up with the package maintainer(s) directly."
  switch ($exitCode) {
    0 { break }
    1 { throw 'Some files could not be extracted.' + $errorMessageAddendum } # this one is returned e.g. for access denied errors
    2 { throw '7-Zip encountered a fatal error while extracting the files.' + $errorMessageAddendum }
    7 { throw ('7-Zip command line error.' + $errorMessageAddendum) }
    8 { throw '7-Zip out of memory.' + $errorMessageAddendum }
    255 { throw 'Extraction cancelled by the user.' + $errorMessageAddendum }
    default { throw "7-Zip signalled an unknown error (code $exitCode)"  + $errorMessageAddendum}
  }

  $env:ChocolateyPackageInstallLocation = $destination
  return $destination
}

# SIG # Begin signature block
# MIIZvwYJKoZIhvcNAQcCoIIZsDCCGawCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAFn3YKWDTeCRUR
# dp3A1AsCp9qMXvMfboyPBkECyxEMuaCCFKgwggT+MIID5qADAgECAhANQkrgvjqI
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
# hkiG9w0BCQQxIgQgfRhydkivPnayqjEAja7HDO4DkSKlDW6D1TnXiDkWsRowDQYJ
# KoZIhvcNAQEBBQAEggEAVqhVi7PY2LAX+ZXL80gReCiqdZmXDXbVoC68il7GUIOo
# WKlsoXXT2ehzrwsixGhGI/zJQDCquCEY53/I5TtNxOb7xnFljwGQzrv/qKGTGKa/
# Nw28P327wu/yTAvljXITADGDgHi0x//YvOZEqFGsnwmC3k+TV1OegUgQPzBttUW2
# 9C8k/a++OLzwPgvyfdrR9mhJXZfDqa7ZV5GyZfAKyvfPnCStUR3yp6rGSi7YnUHT
# tAVlCtIMRxn0UWahge/PEAk3vb470O2x8B7IoKwKeY/gQM+qxtzOzWZV7Bi8A+Wn
# IurnslD0Mn9dBp6uKCfYCcfpe4OW1qQKzQsbdmU+/KGCAjAwggIsBgkqhkiG9w0B
# CQYxggIdMIICGQIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNl
# cnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdp
# Q2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBAhANQkrgvjqI/2BA
# Ic4UAPDdMA0GCWCGSAFlAwQCAQUAoGkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
# ATAcBgkqhkiG9w0BCQUxDxcNMjIwMzMwMDc1MTUyWjAvBgkqhkiG9w0BCQQxIgQg
# 6++Wme8pbdZhs8PVk/wdlM3dIHMXNSpDX/N3LFglqGAwDQYJKoZIhvcNAQEBBQAE
# ggEAl0OlqgVobbJAzUgr3sUaZpPpzwaXkHHzaM9OiHalX9PZlLQ+LfJO7mmArFGg
# 0+Tn9kNfK0bXPhI9nuhRmBZqNQxz3mDEW2QyvmbSgIr0fGLp7GeqPi0vWc3ndocE
# eMvSvmJI0nUA5rh/km0zCCNIGakmpyyiHU+oGSjRljh0YCLZO2p/SAg+et8v8epg
# TEKLmeOdm1PW49KXKLXd8YFs/xf4e4lWE3RLURXVXvYrwUfVLyg1bCVf1jZ4c+AV
# u8OFqQg7yMCFeg0aEEMoW8oxQHnEXZYAo21OZ1muUBRn6lRIkRy5MK5plzpvMibC
# HV9quGrK5PtIXdAWRkkRbZwQFw==
# SIG # End signature block
