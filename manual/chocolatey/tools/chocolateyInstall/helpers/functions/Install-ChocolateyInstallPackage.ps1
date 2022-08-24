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

function Install-ChocolateyInstallPackage {
  <#
.SYNOPSIS
**NOTE:** Administrative Access Required.

Installs software into "Programs and Features". Use
Install-ChocolateyPackage when software must be downloaded first.

.DESCRIPTION
This will run an installer (local file) on your machine.

.NOTES
This command will assert UAC/Admin privileges on the machine.

If you are embedding files into a package, ensure that you have the
rights to redistribute those files if you are sharing this package
publicly (like on the community feed). Otherwise, please use
Install-ChocolateyPackage to download those resources from their
official distribution points.

This is a native installer wrapper function. A "true" package will
contain all the run time files and not an installer. That could come
pre-zipped and require unzipping in a PowerShell script. Chocolatey
works best when the packages contain the software it is managing. Most
software in the Windows world comes as installers and Chocolatey
understands how to work with that, hence this wrapper function.

.INPUTS
None

.OUTPUTS
None

.PARAMETER PackageName
The name of the package - while this is an arbitrary value, it's
recommended that it matches the package id.

.PARAMETER FileType
This is the extension of the file. This can be 'exe', 'msi', or 'msu'.
Licensed editions of Chocolatey use this to automatically determine
silent arguments. If this is not provided, Chocolatey will
automatically determine this using the downloaded file's extension.

.PARAMETER SilentArgs
OPTIONAL - These are the parameters to pass to the native installer,
including any arguments to make the installer silent/unattended.
Pro/Business Editions of Chocolatey will automatically determine the
installer type and merge the arguments with what is provided here.

Try any of the to get the silent installer -
`/s /S /q /Q /quiet /silent /SILENT /VERYSILENT`. With msi it is always
`/quiet`. Please pass it in still but it will be overridden by
Chocolatey to `/quiet`. If you don't pass anything it could invoke the
installer with out any arguments. That means a nonsilent installer.

Please include the `notSilent` tag in your Chocolatey package if you
are not setting up a silent/unattended package. Please note that if you
are submitting to the community repository, it is nearly a requirement
for the package to be completely unattended.

When you are using this with an MSI, it will set up the arguments as
follows: `"C:\Full\Path\To\msiexec.exe" /i "$fileFullPath" $silentArgs`,
where `$fileFullPath` is `$file` or `$file64`, depending on what has been
decided to be used. Previous to 0.10.4, it will be just `$file` as
passing `$file64` would not have been available yet.

When you use this with MSU, it is similar to MSI above in that it finds
the right executable to run.

When you use this with executable installers, the `$fileFullPath` will
be `$file` (or `$file64` starting with 0.10.4+) and expects to be a full
path to the file. If the file is in the package, see the parameters for
"File" and "File64" to determine how you can get that path at runtime in
a deterministic way. SilentArgs is everything you call against that
file, as in `"$fileFullPath" $silentArgs"`. An example would be
`"c:\path\setup.exe" /S`, where `$fileFullPath = "c:\path\setup.exe"`
and `$silentArgs = "/S"`.

.PARAMETER File
Full file path to native installer to run. If embedding in the package,
you can get it to the path with
`"$(Split-Path -parent $MyInvocation.MyCommand.Definition)\\INSTALLER_FILE"`

In 0.10.1+, `FileFullPath` is an alias for File.

This can be a 32-bit or 64-bit file. This is mandatory in earlier versions
of Chocolatey, but optional if File64 has been provided.

.PARAMETER File64
Full file path to a 64-bit native installer to run. Available in 0.10.4+.
If embedding in the package, you can get it to the path with
`"$(Split-Path -parent $MyInvocation.MyCommand.Definition)\\INSTALLER_FILE"`

Provide this when you want to provide both 32-bit and 64-bit
installers or explicitly only a 64-bit installer (which will cause a package
install failure on 32-bit systems).

.PARAMETER ValidExitCodes
Array of exit codes indicating success. Defaults to `@(0)`.

.PARAMETER UseOnlyPackageSilentArguments
Do not allow choco to provide/merge additional silent arguments and
only use the ones available with the package. Available in 0.9.10+.

.PARAMETER IgnoredArguments
Allows splatting with arguments that do not apply. Do not use directly.

.EXAMPLE
>
$packageName= 'bob'
$toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'INSTALLER_EMBEDDED_IN_PACKAGE'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  file          = $fileLocation
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Bob*'
}

Install-ChocolateyInstallPackage @packageArgs

.EXAMPLE
>
$packageArgs = @{
  packageName   = 'bob'
  fileType      = 'exe'
  file          = '\\SHARE_LOCATION\to\INSTALLER_FILE'
  silentArgs    = "/S"
  validExitCodes= @(0)
  softwareName  = 'Bob*'
}

Install-ChocolateyInstallPackage @packageArgs


.EXAMPLE
>
$packageName= 'bob'
$toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'someinstaller.msi'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  file          = $fileLocation
  silentArgs    = "/qn /norestart MSIPROPERTY=`"true`""
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Bob*'
}

Install-ChocolateyInstallPackage @packageArgs

.EXAMPLE
>
$packageName= 'bob'
$toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'someinstaller.msi'
$mstFileLocation = Join-Path $toolsDir 'transform.mst'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  file          = $fileLocation
  silentArgs    = "/qn /norestart TRANSFORMS=`"$mstFileLocation`""
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Bob*'
}

Install-ChocolateyInstallPackage @packageArgs


.EXAMPLE
Install-ChocolateyInstallPackage 'bob' 'exe' '/S' "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)\bob.exe"

.EXAMPLE
>
Install-ChocolateyInstallPackage -PackageName 'bob' -FileType 'exe' `
  -SilentArgs '/S' `
  -File "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)\bob.exe" `
  -ValidExitCodes @(0)

.LINK
Install-ChocolateyPackage

.LINK
Uninstall-ChocolateyPackage

.LINK
Get-UninstallRegistryKey

.LINK
Start-ChocolateyProcessAsAdmin
#>
  param(
    [parameter(Mandatory = $true, Position = 0)][string] $packageName,
    [parameter(Mandatory = $false, Position = 1)]
    [alias("installerType", "installType")][string] $fileType = 'exe',
    [parameter(Mandatory = $false, Position = 2)][string[]] $silentArgs = '',
    [alias("fileFullPath")][parameter(Mandatory = $false, Position = 3)][string] $file,
    [alias("fileFullPath64")][parameter(Mandatory = $false)][string] $file64,
    [parameter(Mandatory = $false)] $validExitCodes = @(0),
    [parameter(Mandatory = $false)]
    [alias("useOnlyPackageSilentArgs")][switch] $useOnlyPackageSilentArguments = $false,
    [parameter(ValueFromRemainingArguments = $true)][Object[]] $ignoredArguments
  )
  [string]$silentArgs = $silentArgs -join ' '

  Write-FunctionCallLogMessage -Invocation $MyInvocation -Parameters $PSBoundParameters

  $bitnessMessage = ''
  $fileFullPath = $file
  if ((Get-ProcessorBits 32) -or $env:ChocolateyForceX86 -eq 'true') {
    if (!$file) { throw "32-bit installation is not supported for $packageName"; }
    if ($file64) { $bitnessMessage = '32-bit '; }
  }
  elseif ($file64) {
    $fileFullPath = $file64
    $bitnessMessage = '64-bit '
  }

  if ($fileFullPath -eq '' -or $fileFullPath -eq $null) {
    throw 'Package parameters incorrect, either File or File64 must be specified.'
  }

  Write-Host "Installing $bitnessMessage$packageName..."

  if ($fileType -eq '' -or $fileType -eq $null) {
    Write-Debug 'No FileType supplied. Using the file extension to determine FileType'
    $fileType = [System.IO.Path]::GetExtension("$fileFullPath").Replace(".", "")
  }

  $installerTypeLower = $fileType.ToLower()
  if ('msi', 'exe', 'msu', 'msp' -notcontains $installerTypeLower) {
    Write-Warning "FileType '$fileType' is unrecognized, using 'exe' instead."
    $fileType = 'exe'
  }

  $env:ChocolateyInstallerType = $fileType

  $additionalInstallArgs = $env:chocolateyInstallArguments;
  if ($additionalInstallArgs -eq $null) {
    $additionalInstallArgs = '';
  }
  else {
    #Use a Regex Or ('|') to do the match, instead of multiple '-or' clauses
    $argPattern = @(
      'INSTALLDIR'
      'TARGETDIR'
      'dir\='
      '\/D\='
  ) -join '|'

    if ($additionalInstallArgs -match $argPattern) {
      @"
Pro / Business supports a single, ubiquitous install directory option.
 Stop the hassle of determining how to pass install directory overrides
 to install arguments for each package / installer type.
 Check out Pro / Business - https://chocolatey.org/compare"
"@ | Write-Warning
    }
  }
  $overrideArguments = $env:chocolateyInstallOverride;

  # remove \chocolatey\chocolatey\
  # might be a slight issue here if the download path is the older
  $silentArgs = $silentArgs -replace '\\chocolatey\\chocolatey\\', '\chocolatey\'
  $additionalInstallArgs = $additionalInstallArgs -replace '\\chocolatey\\chocolatey\\', '\chocolatey\'
  $updatedFilePath = $fileFullPath -replace '\\chocolatey\\chocolatey\\', '\chocolatey\'
  if ([System.IO.File]::Exists($updatedFilePath)) {
    $fileFullPath = $updatedFilePath
  }

  $ignoreFile = $fileFullPath + '.ignore'
  if ($env:ChocolateyInstall -and $ignoreFile -match [System.Text.RegularExpressions.Regex]::Escape($env:ChocolateyInstall)) {
    try {
      '' | out-file $ignoreFile
    }
    catch {
      Write-Warning "Unable to generate `'$ignoreFile`'"
    }
  }

  $workingDirectory = Get-Location -PSProvider "FileSystem"
  try {
    $workingDirectory = [System.IO.Path]::GetDirectoryName($fileFullPath)
  }
  catch {
    Write-Warning "Unable to set the working directory for installer to location of '$fileFullPath'"
    $workingDirectory = $env:TEMP
  }

  try {
    # make sure any logging folder exists
    $pattern = "(?:['`"])([a-zA-Z]\:\\[^'`"]+)(?:[`"'])|([a-zA-Z]\:\\[\S]+)"
    $silentArgs, $additionalInstallArgs | % { Select-String $pattern -input $_ -AllMatches } |
    % { $_.Matches } | % {
      $argDirectory = $_.Groups[1]
      if ($argDirectory -eq $null -or $argDirectory -eq '') { continue }
      $argDirectory = [System.IO.Path]::GetFullPath([System.IO.Path]::GetDirectoryName($argDirectory))
      Write-Debug "Ensuring '$argDirectory' exists"
      if (![System.IO.Directory]::Exists($argDirectory)) { [System.IO.Directory]::CreateDirectory($argDirectory) | Out-Null }
    }
  }
  catch {
    Write-Debug "Error ensuring directories exist -  $($_.Exception.Message)"
  }

  if ($fileType -like 'msi') {
    $msiArgs = "/i `"$fileFullPath`""
    $msiArgs = if ($overrideArguments) {
      Write-Host "Overriding package arguments with '$additonalInstallArgs' (replacing '$silentArgs')"
      "$msiArgs $additionalInstallArgs"
    }
    else {
      "$msiArgs $silentArgs $additionalInstallArgs"
    }

    $env:ChocolateyExitCode = Start-ChocolateyProcessAsAdmin "$msiArgs" "$($env:SystemRoot)\System32\msiexec.exe" -validExitCodes $validExitCodes -workingDirectory $workingDirectory
  }

  if ($fileType -like 'msp') {
    $msiArgs = '/update "{0}"' -f $fileFullPath
    if ($overrideArguments) {
      Write-Host "Overriding package arguments with '$additionalInstallArgs' (replacing '$silentArgs')";
      $msiArgs = "$msiArgs $additionalInstallArgs";
    }
    else {
      $msiArgs = "$msiArgs $silentArgs $additionalInstallArgs";
    }

    $env:ChocolateyExitCode = Start-ChocolateyProcessAsAdmin "$msiArgs" "$($env:SystemRoot)\System32\msiexec.exe" -validExitCodes $validExitCodes -workingDirectory $workingDirectory
  }

  if ($fileType -like 'exe') {
    if ($overrideArguments) {
      Write-Host "Overriding package arguments with '$additionalInstallArgs' (replacing '$silentArgs')";
      $env:ChocolateyExitCode = Start-ChocolateyProcessAsAdmin "$additionalInstallArgs" $fileFullPath -validExitCodes $validExitCodes -workingDirectory $workingDirectory
    }
    else {
      $env:ChocolateyExitCode = Start-ChocolateyProcessAsAdmin "$silentArgs $additionalInstallArgs" $fileFullPath -validExitCodes $validExitCodes -workingDirectory $workingDirectory
    }
  }

  if ($fileType -like 'msu') {
    if ($overrideArguments) {
      Write-Host "Overriding package arguments with '$additionalInstallArgs' (replacing '$silentArgs')";
      $msuArgs = "`"$fileFullPath`" $additionalInstallArgs"
    }
    else {
      $msuArgs = "`"$fileFullPath`" $silentArgs $additionalInstallArgs"
    }
    $env:ChocolateyExitCode = Start-ChocolateyProcessAsAdmin "$msuArgs" "$($env:SystemRoot)\System32\wusa.exe" -validExitCodes $validExitCodes -workingDirectory $workingDirectory
  }

  Write-Host "$packageName has been installed."
}

# SIG # Begin signature block
# MIIZvwYJKoZIhvcNAQcCoIIZsDCCGawCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBp+F+1jnZGUroX
# Tvvlz6LmPOKazaXRCI59MlwFMmxWqqCCFKgwggT+MIID5qADAgECAhANQkrgvjqI
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
# hkiG9w0BCQQxIgQgzDeIONkYgBz0dpWDf35NbtutAQvRtq677dX4cbPJFTgwDQYJ
# KoZIhvcNAQEBBQAEggEAcWZQ6dy2iiIfBj4dUNb8cvasK9zxTfSkXN5UdrfnGNZT
# hNz6z31vRWWTdUeCs7eJ1x8ritxWmcnuWOCvR0AboCswbdzHoY4p2nMP5sRmnzaP
# gKbLwQo2EGmzFnklChkuLHefoXe/O7Pdw++aF8ASxd5ZihswKOp+K7K+IqkU80fi
# dv7wRheHDrls1JG4V/vkE7ZwHFKj+scvv/XziNXhqUbN7eNGkrjpcod06M5Ibb1X
# eA0GusLuYUqGvnn5sSsDsjOxu566Cut9zbLyfqWKGOSViHNaeemaFa2xas3dB5iH
# lmNnz+aFUOK0cDHbSq+l4d48ubkYUVC0AR9eq0pyEaGCAjAwggIsBgkqhkiG9w0B
# CQYxggIdMIICGQIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNl
# cnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdp
# Q2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBAhANQkrgvjqI/2BA
# Ic4UAPDdMA0GCWCGSAFlAwQCAQUAoGkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
# ATAcBgkqhkiG9w0BCQUxDxcNMjIwMzMwMDc1MTU0WjAvBgkqhkiG9w0BCQQxIgQg
# w4/RYkRQ3VpD00lHXZh49oWiKxEmTIiGdWO9mftUnhcwDQYJKoZIhvcNAQEBBQAE
# ggEAV2ca56IG4JrvgRsb7g+ZpYAZoHmQXpV4gvvdTGE/EqG7yaXjSVW7MJK5bK4w
# tMuWkYBSNH/kf8sinMw53ZHFSsyd94QLtrXhK/qJUT4ptLLwkTvEzRF7ucvFHT4D
# 23YmIDGtQZSrOIwg6h5eQtSTBbXjI7NhBztooHfKII3Hu0TV/FWdctE3hgs7uuMh
# 5s1a9/xk0jY7au2ZDwGWn4fmEqx5IXdaFJwXhuiYQXjombVEpLOaqYtcc8VlV8GE
# UXMLEFqhzzPLSKYcPbNaySSbIqecC71EaLDMQ4qu+d2iZtZRA+Gyq13cqU5XHQMN
# uilvEpq3Vp/a1oMUB72AE3k2Ow==
# SIG # End signature block
