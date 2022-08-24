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

function Install-ChocolateyPackage {
<#
.SYNOPSIS
**NOTE:** Administrative Access Required.

Installs software into "Programs and Features" based on a remote file
download. Use Install-ChocolateyInstallPackage when local or embedded
file.

Building packages for an organization or for use internally? You want to
use Install-ChocolateyINSTALLPackage instead of this method (see links
below).

.DESCRIPTION
This will download a native installer from a url and install it on your
machine. Has error handling built in.

If you are embedding the file(s) directly in the package (or do not need
to download a file first), use Install-ChocolateyInstallPackage instead.

Building packages for an organization or for use internally? You want to
use Install-ChocolateyINSTALLPackage instead of this method
(see links below).

.NOTES
This command will assert UAC/Admin privileges on the machine.

This is a native installer wrapper function. A "true" package will
contain all the run time files and not an installer. That could come
pre-zipped and require unzipping in a PowerShell script. Chocolatey
works best when the packages contain the software it is managing. Most
software in the Windows world comes as installers and Chocolatey
understands how to work with that, hence this wrapper function.

Chocolatey works best when the packages contain the software it is
managing and doesn't require downloads. However most software in the
Windows world requires redistribution rights and when sharing packages
publicly (like on the community feed), maintainers may not have those
aforementioned rights. Chocolatey understands how to work with that,
hence this function. You are not subject to this limitation with
internal packages.

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
Licensed editions of Chocolatey will automatically determine the
installer type and merge the arguments with what is provided here.

Try any of the to get the silent (unattended) installer -
`/s /S /q /Q /quiet /silent /SILENT /VERYSILENT`. With msi it is always
`/quiet`. Please pass it in still but it will be overridden by
Chocolatey to `/quiet`. If you don't pass anything it could invoke the
installer with out any arguments. That means a nonsilent installer.

Please include the `notSilent` tag in your Chocolatey package if you
are not setting up a silent/unattended package. Please note that if you
are submitting to the community repository, it is nearly a requirement
for the package to be completely unattended.

When you are using this with an MSI, it will set up the arguments as
follows:
`"C:\Full\Path\To\msiexec.exe" /i "$downloadedFileFullPath" $silentArgs`,
where `$downloadedfileFullPath` is `$url` or `$url64`, depending on what
has been decided to be used.

When you use this with MSU, it is similar to MSI above in that it finds
the right executable to run.

When you use this with executable installers, the
`$downloadedFileFullPath` will also be `$url`/`$url64` SilentArgs is
everything you call against that file, as in
`"$fileFullPath" $silentArgs"`. An example would be
`"c:\path\setup.exe" /S`, where
`$downloadedfileFullPath = "c:\path\setup.exe"` and `$silentArgs = "/S"`.

.PARAMETER Url
This is the 32 bit url to download the resource from. This resource can
be used on 64 bit systems when a package has both a Url and Url64bit
specified if a user passes `--forceX86`. If there is only a 64 bit url
available, please remove do not use the parameter (only use Url64bit).
Will fail on 32bit systems if missing or if a user attempts to force
a 32 bit installation on a 64 bit system.

Prefer HTTPS when available. Can be HTTP, FTP, or File URIs.

.PARAMETER Url64bit
OPTIONAL - If there is a 64 bit resource available, use this
parameter. Chocolatey will automatically determine if the user is
running a 64 bit OS or not and adjust accordingly. Please note that
the 32 bit url will be used in the absence of this. This parameter
should only be used for 64 bit native software. If the original Url
contains both (which is quite rare), set this to '$url' Otherwise remove
this parameter.

Prefer HTTPS when available. Can be HTTP, FTP, or File URIs.

.PARAMETER ValidExitCodes
Array of exit codes indicating success. Defaults to `@(0)`.

.PARAMETER Checksum
The checksum hash value of the Url resource. This allows a checksum to
be validated for files that are not local. The checksum type is covered
by ChecksumType.

**NOTE:** Checksums in packages are meant as a measure to validate the
originally intended file that was used in the creation of a package is
the same file that is received at a future date. Since this is used for
other steps in the process related to the community repository, it
ensures that the file a user receives is the same file a maintainer
and a moderator (if applicable), plus any moderation review has
intended for you to receive with this package. If you are looking at a
remote source that uses the same url for updates, you will need to
ensure the package also stays updated in line with those remote
resource updates. You should look into [automatic packaging](https://docs.chocolatey.org/en-us/create/automatic-packages)
to help provide that functionality.

**NOTE:** To determine checksums, you can get that from the original
site if provided. You can also use the [checksum tool available on
the community feed](https://community.chocolatey.org/packages/checksum) (`choco install checksum`)
and use it e.g. `checksum -t sha256 -f path\to\file`. Ensure you
provide checksums for all remote resources used.

.PARAMETER ChecksumType
The type of checksum that the file is validated with - valid
values are 'md5', 'sha1', 'sha256' or 'sha512' - defaults to 'md5'.

MD5 is not recommended as certain organizations need to use FIPS
compliant algorithms for hashing - see
https://support.microsoft.com/en-us/kb/811833 for more details.

The recommendation is to use at least SHA256.

.PARAMETER Checksum64
OPTIONAL if no Url64bit - The checksum hash value of the Url64bit
resource. This allows a checksum to be validated for files that are not
local. The checksum type is covered by ChecksumType64.

**NOTE:** Checksums in packages are meant as a measure to validate the
originally intended file that was used in the creation of a package is
the same file that is received at a future date. Since this is used for
other steps in the process related to the community repository, it
ensures that the file a user receives is the same file a maintainer
and a moderator (if applicable), plus any moderation review has
intended for you to receive with this package. If you are looking at a
remote source that uses the same url for updates, you will need to
ensure the package also stays updated in line with those remote
resource updates. You should look into [automatic packaging](https://docs.chocolatey.org/en-us/create/automatic-packages)
to help provide that functionality.

.PARAMETER ChecksumType64
OPTIONAL - The type of checksum that the file is validated with - valid
values are 'md5', 'sha1', 'sha256' or 'sha512' - defaults to
ChecksumType parameter value.

MD5 is not recommended as certain organizations need to use FIPS
compliant algorithms for hashing - see
https://support.microsoft.com/en-us/kb/811833 for more details.

The recommendation is to use at least SHA256.

.PARAMETER Options
OPTIONAL - Specify custom headers. Available in 0.9.10+.

.PARAMETER File
Will be used for Url if Url is empty. Available in 0.10.7+.

This parameter provides compatibility, but should not be used directly
and not with the community package repository until January 2018.

.PARAMETER File64
Will be used for Url64bit if Url64bit is empty. Available in 0.10.7+.

This parameter provides compatibility, but should not be used directly
and not with the community package repository until January 2018.

.PARAMETER UseOnlyPackageSilentArguments
Do not allow choco to provide/merge additional silent arguments and only
use the ones available with the package. Available in 0.9.10+.

.PARAMETER UseOriginalLocation
Do not download the resources. This is typically passed if Url/Url64bit
are pointed to local files or files on a share and those files should
be used in place. Available in 0.10.1+.

NOTE: You can also use `Install-ChocolateyInstallPackage` for the same
functionality (see links).

.PARAMETER IgnoredArguments
Allows splatting with arguments that do not apply. Do not use directly.

.PARAMETER BeforeInstall Script
Specifies the commands to run after download has completed but before install steps have begun.
Available in 0.11.0+.

Use this for starting an auxilary process such as AutoHotkey, so that any timeouts are not 
affected by the time to download.

.EXAMPLE
>
$packageName= 'bob'
$toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://somewhere.com/file.msi'
$url64      = 'https://somewhere.com/file-x64.msi'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Bob*'
  checksum      = '12345'
  checksumType  = 'sha256'
  checksum64    = '123356'
  checksumType64= 'sha256'
}

Install-ChocolateyPackage @packageArgs

.EXAMPLE
>
$packageName= 'bob'
$toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://somewhere.com/file.msi'
$url64      = 'https://somewhere.com/file-x64.msi'


$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64
  silentArgs    = "/qn /norestart MSIPROPERTY=`"true`""
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Bob*'
  checksum      = '12345'
  checksumType  = 'sha256'
  checksum64    = '123356'
  checksumType64= 'sha256'
}

Install-ChocolateyPackage @packageArgs

.EXAMPLE
>
$packageName= 'bob'
$toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$urlTransform = 'https://somewhere.com/file.mst'
$mstFileLocation = Join-Path $toolsDir 'transform.mst'

Get-ChocolateyWebFile -PackageName 'bob' `
                      -Url $urlTransform -FileFullPath $mstFileLocation `
                      -Checksum '1234' -ChecksumType 'sha256'

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
>
Install-ChocolateyPackage 'StExBar' 'msi' '/quiet' `
 'http://stexbar.googlecode.com/files/StExBar-1.8.3.msi' `
 'http://stexbar.googlecode.com/files/StExBar64-1.8.3.msi'

.EXAMPLE
>
Install-ChocolateyPackage 'mono' 'exe' '/SILENT' `
 'http://somehwere/something.exe' -ValidExitCodes @(0,21)

.EXAMPLE
>
Install-ChocolateyPackage 'ruby.devkit' 'exe' '/SILENT' `
 'http://cdn.rubyinstaller.org/archives/devkits/DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe' `
 'http://cdn.rubyinstaller.org/archives/devkits/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe' `
 -checksum '9383f12958aafc425923e322460a84de' -checksumType 'md5' `
 -checksum64 'ce99d873c1acc8bffc639bd4e764b849'

.EXAMPLE
Install-ChocolateyPackage 'bob' 'exe' '/S' 'https://somewhere/bob.exe' 'https://somewhere/bob-x64.exe'

.EXAMPLE
>
$options =
@{
  Headers = @{
    Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';
    'Accept-Charset' = 'ISO-8859-1,utf-8;q=0.7,*;q=0.3';
    'Accept-Language' = 'en-GB,en-US;q=0.8,en;q=0.6';
    Cookie = 'requiredinfo=info';
    Referer = 'https://somelocation.com/';
  }
}

Install-ChocolateyPackage -PackageName 'package' -FileType 'exe' -SilentArgs '/S' 'https://somelocation.com/thefile.exe' -Options $options

.LINK
Get-ChocolateyWebFile

.LINK
Install-ChocolateyInstallPackage

.LINK
Get-UninstallRegistryKey

.LINK
Install-ChocolateyZipPackage
#>
param(
  [parameter(Mandatory=$true, Position=0)][string] $packageName,
  [parameter(Mandatory=$false, Position=1)]
  [alias("installerType","installType")][string] $fileType = 'exe',
  [parameter(Mandatory=$false, Position=2)][string[]] $silentArgs = '',
  [parameter(Mandatory=$false, Position=3)][string] $url = '',
  [parameter(Mandatory=$false, Position=4)]
  [alias("url64")][string] $url64bit = '',
  [parameter(Mandatory=$false)] $validExitCodes = @(0),
  [parameter(Mandatory=$false)][string] $checksum = '',
  [parameter(Mandatory=$false)][string] $checksumType = '',
  [parameter(Mandatory=$false)][string] $checksum64 = '',
  [parameter(Mandatory=$false)][string] $checksumType64 = '',
  [parameter(Mandatory=$false)][hashtable] $options = @{Headers=@{}},
  [alias("fileFullPath")][parameter(Mandatory=$false)][string] $file = '',
  [alias("fileFullPath64")][parameter(Mandatory=$false)][string] $file64 = '',
  [parameter(Mandatory=$false)]
  [alias("useOnlyPackageSilentArgs")][switch] $useOnlyPackageSilentArguments = $false,
  [parameter(Mandatory=$false)][switch]$useOriginalLocation,
  [parameter(Mandatory=$false)][scriptblock] $beforeInstall,
  [parameter(ValueFromRemainingArguments = $true)][Object[]] $ignoredArguments
)
  [string]$silentArgs = $silentArgs -join ' '

  Write-FunctionCallLogMessage -Invocation $MyInvocation -Parameters $PSBoundParameters

  $chocTempDir = $env:TEMP
  $tempDir = Join-Path $chocTempDir "$($env:chocolateyPackageName)"
  if ($env:chocolateyPackageVersion -ne $null) { $tempDir = Join-Path $tempDir "$($env:chocolateyPackageVersion)"; }
  $tempDir = $tempDir -replace '\\chocolatey\\chocolatey\\', '\chocolatey\'
  if (![System.IO.Directory]::Exists($tempDir)) { [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null }
  $downloadFilePath = Join-Path $tempDir "$($packageName)Install.$fileType"

  if ($url -eq '' -or $url -eq $null) {
    $url = $file
  }
  if ($url64bit -eq '' -or $url64bit -eq $null) {
    $url64bit = $file64
  }

  [string]$filePath = $downloadFilePath
  if ($useOriginalLocation) {
    $filePath = $url
    if (Get-ProcessorBits 64) {
      $forceX86 = $env:chocolateyForceX86
      if ($forceX86) {
        Write-Debug "User specified '-x86' so forcing 32-bit"
      } else {
        if ($url64bit -ne $null -and $url64bit -ne '') {
          $filePath = $url64bit
        }
      }
    }
  } else {
    $filePath = Get-ChocolateyWebFile -PackageName $packageName `
                                      -FileFullPath $downloadFilePath `
                                      -Url $url `
                                      -Url64bit $url64bit `
                                      -Checksum $checksum `
                                      -ChecksumType $checksumType `
                                      -Checksum64 $checksum64 `
                                      -ChecksumType64 $checksumType64 `
                                      -Options $options `
                                      -GetOriginalFileName
  }

  if ($beforeInstall) {
    & $beforeInstall
  }

  Install-ChocolateyInstallPackage -PackageName $packageName `
                                   -FileType $fileType `
                                   -SilentArgs $silentArgs `
                                   -File $filePath `
                                   -ValidExitCodes $validExitCodes `
                                   -UseOnlyPackageSilentArguments:$useOnlyPackageSilentArguments
}

# SIG # Begin signature block
# MIIZvwYJKoZIhvcNAQcCoIIZsDCCGawCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCawdnu8BMNMZtH
# aH1gZF9lOhEm4upm79//etHiVTv+mKCCFKgwggT+MIID5qADAgECAhANQkrgvjqI
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
# hkiG9w0BCQQxIgQg9NAbab0hyCf28kcmztkkl4WSzJfYPtCB7EJFiDDXwYowDQYJ
# KoZIhvcNAQEBBQAEggEARybyM9lSTCfioMFxEEn+IL1VSWMoABoeiqJcn/UOeTKs
# GGbt+uhttQMDG0taVqLRj9Gx10BpXQmYEgG9ne2txzAjKBn2HzSXBBElrO6g7/KR
# prihbvzW8F3bVaPZe3rf4Was9YNRNdgT19ChvzKUZ4X38wNG+9ViCWhksjrlM60Y
# hgLYBQIGdH1dJtu7pxHlmWG6KDRg8caRbxYuchnG+NISnSdB18iogMr7YS/CEeXQ
# NuxRFEm47GfPCbeojzGrcvESPu9oI0Hzur3hYJ0em7HD8dPhab+2vzXU/bP/FV+z
# xkZ6HhV8suPHJiP3ytOxmX5XiPj72y7BdwXWuFQXXKGCAjAwggIsBgkqhkiG9w0B
# CQYxggIdMIICGQIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNl
# cnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdp
# Q2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBAhANQkrgvjqI/2BA
# Ic4UAPDdMA0GCWCGSAFlAwQCAQUAoGkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
# ATAcBgkqhkiG9w0BCQUxDxcNMjIwMzMwMDc1MTU1WjAvBgkqhkiG9w0BCQQxIgQg
# WPuYuxqPFoSD4izxjDLlc9XC6zcGUCgq/VFeW+KI5AowDQYJKoZIhvcNAQEBBQAE
# ggEAIuomM655UuUM7ry8SWM68rokF0qTC7Rc+5aGdYsPj9bUjITQK3ANq+ynW2cX
# LIPf1eNqeH/Ah1DT0FqU4J4lFp1S7KDD7iPMlK6XL01FellNn/Srd3HLnz5kRmcX
# Sl4LaIt5txZ7yKY4KQ5pSmhxNU61VQEz+2EBaa2tnNCAasDEQq1AOPFgpfx2TQOk
# l0vnAzOX74MS3ngSoCcwgxELP9PaF35YGsFFCyTZYE5+Gudp6EC+gC7gSt0aHtOy
# pWPBHFPM/W/5JSL50NO6Vm7vkVgKbgeiwkRUGygdadi61Rtl3HIW7PpScYXdoZB8
# arhFHcfSe0fn2XDnLhAnRUQ3Dw==
# SIG # End signature block
