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

function Get-ChocolateyWebFile {
<#
.SYNOPSIS
Downloads a file from the internets.

.DESCRIPTION
This will download a file from a url, tracking with a progress bar.
It returns the filepath to the downloaded file when it is complete.

.NOTES
Chocolatey works best when the packages contain the software it is
managing and doesn't require downloads. However most software in the
Windows world requires redistribution rights and when sharing packages
publicly (like on the community feed), maintainers may not have those
aforementioned rights. Chocolatey understands how to work with that,
hence this function. You are not subject to this limitation with
internal packages.

.PARAMETER PackageName
The name of the package - while this is an arbitrary value, it's
recommended that it matches the package id.

.PARAMETER FileFullPath
This is the full path of the resulting file name.

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
contains both (which is quite rare), set this to '$url' Otherwise
remove this parameter.

Prefer HTTPS when available. Can be HTTP, FTP, or File URIs.

In 0.10.1+, `Url64` is an alias for Url64bit.

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

**NOTE:** To determine checksums, you can get that from the original
site if provided. You can also use the [checksum tool available on
the community feed](https://community.chocolatey.org/packages/checksum) (`choco install checksum`)
and use it e.g. `checksum -t sha256 -f path\to\file`. Ensure you
provide checksums for all remote resources used.

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

.PARAMETER GetOriginalFileName
OPTIONAL switch to allow Chocolatey to determine the original file name
from the url resource. Available in 0.9.10+.

.PARAMETER ForceDownload
OPTIONAL switch to force download of file every time, even if the file
already exists.

Available in 0.10.1+.

.PARAMETER IgnoredArguments
Allows splatting with arguments that do not apply. Do not use directly.

.EXAMPLE
Get-ChocolateyWebFile '__NAME__' 'C:\somepath\somename.exe' 'URL' '64BIT_URL_DELETE_IF_NO_64BIT'

.EXAMPLE
>
# Download from an HTTPS location
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Get-ChocolateyWebFile -PackageName 'bob' -FileFullPath "$toolsDir\bob.exe" -Url 'https://somewhere/bob.exe'

.EXAMPLE
>
# Download from FTP
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
Get-ChocolateyWebFile -PackageName 'bob' -FileFullPath "$toolsDir\bob.exe" -Url 'ftp://somewhere/bob.exe'

.EXAMPLE
>
# Download from a file share
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
Get-ChocolateyWebFile -PackageName 'bob' -FileFullPath "$toolsDir\bob.exe" -Url 'file:///\\fileshare\location\bob.exe'

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

Get-ChocolateyWebFile -PackageName 'package' -FileFullPath "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)\thefile.exe" -Url 'https://somelocation.com/thefile.exe' -Options $options

.LINK
Install-ChocolateyPackage

.LINK
Get-WebFile

.LINK
Get-WebFileName

.LINK
Get-FtpFile
#>
param(
  [parameter(Mandatory=$true, Position=0)][string] $packageName,
  [parameter(Mandatory=$true, Position=1)][string] $fileFullPath,
  [parameter(Mandatory=$false, Position=2)][string] $url = '',
  [parameter(Mandatory=$false, Position=3)]
  [alias("url64")][string] $url64bit = '',
  [parameter(Mandatory=$false)][string] $checksum = '',
  [parameter(Mandatory=$false)][string] $checksumType = '',
  [parameter(Mandatory=$false)][string] $checksum64 = '',
  [parameter(Mandatory=$false)][string] $checksumType64 = $checksumType,
  [parameter(Mandatory=$false)][hashtable] $options = @{Headers=@{}},
  [parameter(Mandatory=$false)][switch] $getOriginalFileName,
  [parameter(Mandatory=$false)][switch] $forceDownload,
  [parameter(ValueFromRemainingArguments = $true)][Object[]] $ignoredArguments
)

  Write-FunctionCallLogMessage -Invocation $MyInvocation -Parameters $PSBoundParameters

  # url overrides
  $urlOverride = $env:ChocolateyUrlOverride
  $url64bitOverride = $env:ChocolateyUrl64bitOverride
  if ($urlOverride -ne $null -and $urlOverride -ne '') { $url = $urlOverride }
  if ($url64bitOverride -ne $null -and $url64bitOverride -ne '') { $url64bit = $url64bitOverride }

  if ($url -ne $null) { $url = $url.Replace("//","/").Replace(":/","://") }
  if ($url64bit -ne $null) { $url64bit = $url64bit.Replace("//","/").Replace(":/","://") }

  $url32bit = $url

  # allow user provided values for checksumming
  $checksum32Override = $env:chocolateyChecksum32
  $checksumType32Override = $env:chocolateyChecksumType32
  $checksum64Override = $env:chocolateyChecksum64
  $checksumType64Override = $env:chocolateyChecksumType64
  if ($checksum32Override -ne $null -and $checksum32Override -ne '') { $checksum = $checksum32Override }
  if ($checksumType32Override -ne $null -and $checksumType32Override -ne '') { $checksumType = $checksumType32Override }
  if ($checksum64Override -ne $null -and $checksum64Override -ne '') { $checksum64 = $checksum64Override }
  if ($checksumType64Override -ne $null -and $checksumType64Override -ne '') { $checksumType64 = $checksumType64Override }

  $checksum32 = $checksum
  $checksumType32 = $checksumType
  $bitWidth = 32
  if (Get-ProcessorBits 64) {
    $bitWidth = 64
  }
  Write-Debug "CPU is $bitWidth bit"

  $bitPackage = ''
  if ($url32bit -ne $url64bit -and $url64bit -ne $null -and $url64bit -ne '') { $bitPackage = '32 bit' }

  if ($bitWidth -eq 64 -and $url64bit -ne $null -and $url64bit -ne '') {
    Write-Debug "Setting url to '$url64bit' and bitPackage to $bitWidth"
    $bitPackage = '64 bit'
    $url = $url64bit
    # only set if urls are different
    if ($url32bit -ne $url64bit) {
      $checksum = $checksum64
      if ($checkSumType64 -ne '') {
        $checksumType = $checksumType64
      }
    }
  }

  $forceX86 = $env:chocolateyForceX86;
  if ($forceX86) {
    Write-Debug "User specified -x86 so forcing 32 bit"
    if ($url32bit -ne $url64bit) { $bitPackage = '32 bit' }
    $url = $url32bit
    $checksum =  $checksum32
    $checksumType = $checksumType32
  }

  # If we're on 32 bit or attempting to force 32 bit and there is no
  # 32 bit url, we need to throw an error.
  if ($url -eq $null -or $url -eq '') {
    throw "This package does not support $bitPackage architecture."
  }

  # determine if the url can be SSL/TLS
  if ($url.StartsWith('http:')) {
    try {
      $httpsUrl = $url.Replace("http://", "https://")
      Get-WebHeaders -Url $httpsUrl -ErrorAction "Stop" | Out-Null
      $url = $httpsUrl
      Write-Warning "Url has SSL/TLS available, switching to HTTPS for download"
    } catch {
      Write-Debug "Url does not have HTTPS available"
    }
  }

  if ($getOriginalFileName) {
    try {
      $fileFullPath = $fileFullPath -replace '\\chocolatey\\chocolatey\\', '\chocolatey\'
      $fileDirectory = [System.IO.Path]::GetDirectoryName($fileFullPath)
      $originalFileName = [System.IO.Path]::GetFileName($fileFullPath)
      $fileFullPath = Get-WebFileName -Url $url -DefaultName $originalFileName
      $fileFullPath = Join-Path $fileDirectory $fileFullPath
      $fileFullPath = [System.IO.Path]::GetFullPath($fileFullPath)
    } catch {
      Write-Host "Attempt to use original download file name failed for '$url'."
    }
  }

  try {
    $fileDirectory = $([System.IO.Path]::GetDirectoryName($fileFullPath))
    if (!(Test-Path($fileDirectory))) {
      [System.IO.Directory]::CreateDirectory($fileDirectory) | Out-Null
    }
  } catch {
    Write-Host "Attempt to create directory failed for '$fileFullPath'."
  }

  $urlIsRemote = $true
  $headers = @{}
  if ($url.StartsWith('http')) {
    try {
      $headers = Get-WebHeaders -Url $url -ErrorAction "Stop"
    } catch {
      if ($PSVersionTable.PSVersion -lt (New-Object 'Version' 3,0)) {
        Write-Debug "Converting Security Protocol to SSL3 only for PowerShell v2"
        # this should last for the entire duration
        $originalProtocol = [System.Net.ServicePointManager]::SecurityProtocol
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Ssl3
        try {
          $headers = Get-WebHeaders -Url $url -ErrorAction "Stop"
        } catch {
          Write-Host "Attempt to get headers for $url failed.`n  $($_.Exception.Message)"
          [System.Net.ServicePointManager]::SecurityProtocol = $originalProtocol
        }
      } else {
        Write-Host "Attempt to get headers for $url failed.`n  $($_.Exception.Message)"
      }
    }

    $needsDownload = $true
    $fiCached = New-Object System.IO.FileInfo($fileFullPath)
    if ($fiCached.Exists -and -not ($forceDownload)) {
      if ($checksum -ne $null -and $checksum -ne '') {
          try {
            Write-Host "File appears to be downloaded already. Verifying with package checksum to determine if it needs to be redownloaded."
            Get-ChecksumValid -file $fileFullPath -checkSum $checksum -checksumType $checksumType -originalUrl $url -ErrorAction "Stop"
            $needsDownload = $false
          } catch {
            Write-Debug "Existing file failed checksum. Will be redownloaded from url."
          }
      }
      elseif ($headers.Count -ne 0 -and $headers.ContainsKey("Content-Length")) {
        # if the file already exists there is no reason to download it again.
        if ($fiCached.Length -eq $headers["Content-Length"]) { $needsDownload = $false }
      }
    }

    if ($needsDownload) {
      Write-Host "Downloading $packageName $bitPackage
  from `'$url`'"
      Get-WebFile -Url $url -FileName $fileFullPath -Options $options
    } else {
      Write-Debug "$($packageName)'s requested file has already been downloaded. Using cached copy at
 '$fileFullPath'."
    }
  } elseif ($url.StartsWith('ftp')) {
    Write-Host "Ftp-ing $packageName
  from '$url'"
    Get-FtpFile -Url $url -FileName $fileFullPath
  } else {
    if ($url.StartsWith('file:')) { $url = ([uri] $url).LocalPath }
    Write-Host "Copying $packageName
  from `'$url`'"
    Copy-Item $url -Destination $fileFullPath -Force
    $urlIsRemote = $false
  }

  Start-Sleep 2 #give it a sec or two to finish up copying

  $fi = New-Object System.IO.FileInfo($fileFullPath)
  # validate file exists
  if (!($fi.Exists)) { throw "Chocolatey expected a file to be downloaded to `'$fileFullPath`' but nothing exists at that location." }

  Get-VirusCheckValid -Location $url -File $fileFullPath

  if ($headers.Count -ne 0 -and ($checksum -eq $null -or $checksum -eq '')) {
    # validate length is what we expected
    Write-Debug "Checking that '$fileFullPath' is the size we expect it to be."
    if ($headers.ContainsKey("Content-Length") -and ($fi.Length -ne $headers["Content-Length"]))  { throw "Chocolatey expected a file at '$fileFullPath' to be of length '$($headers["Content-Length"])' but the length was '$($fi.Length)'." }

    if ($headers.ContainsKey("X-Checksum-Sha1")) {
      $remoteChecksum = $headers["X-Checksum-Sha1"]
      Write-Debug "Verifying remote checksum of '$remoteChecksum' for '$fileFullPath'."
      Get-ChecksumValid -File $fileFullPath -Checksum $remoteChecksum -ChecksumType 'sha1' -OriginalUrl $url
    }
  }

  #skip requirement for embedded files if checksum is not provided
  if ($urlIsRemote -or ($checksum -ne $null -and $checksum -ne '')) {
    Write-Debug "Verifying package provided checksum of '$checksum' for '$fileFullPath'."
    Get-ChecksumValid -File $fileFullPath -Checksum $checksum -ChecksumType $checksumType -OriginalUrl $url
  }

  return $fileFullPath
}

# SIG # Begin signature block
# MIIZvwYJKoZIhvcNAQcCoIIZsDCCGawCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDK+yswuj30wIzX
# n1A/kqyo3gwhs4ch0Fkj+4yyy1BtfKCCFKgwggT+MIID5qADAgECAhANQkrgvjqI
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
# hkiG9w0BCQQxIgQgHNgLMHzYiitZ5LZsUQHwpWqWgnaEIRvEb36L8GVtetMwDQYJ
# KoZIhvcNAQEBBQAEggEADE/oEff2DnKuTBY5EPmt0ML171TBWxl2OSIF0N2O31Q2
# UZ3/iPpFC7jQafHxhbK6xz5tJURIutEHxmWxPC3oaDUsBY7EOrnXdTiipSObx0kc
# 1xxXIBX/mM8Ivy7+mA/OUzR/TiKyEQnlCPYLp7zop3Iri1TC8KLnbuUkvPecMm1D
# GszzulNpe8IFZsmoOwmIMzmkhvfcKzfHy1KfCFwMNfJmUNO0oJMLIlnhgmTapSwi
# z6uBKS0XIH8kibnt98WQxVKJVKl4Ce0wZFi13wKg78c89Evjl7m93kph6Q6f0q1C
# js5jqnzFvbhEDFxotRtpmj+FKUAmvUleGfOkpV1k+aGCAjAwggIsBgkqhkiG9w0B
# CQYxggIdMIICGQIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNl
# cnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdp
# Q2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBAhANQkrgvjqI/2BA
# Ic4UAPDdMA0GCWCGSAFlAwQCAQUAoGkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
# ATAcBgkqhkiG9w0BCQUxDxcNMjIwMzMwMDc1MTUyWjAvBgkqhkiG9w0BCQQxIgQg
# DKDAODsAbQZGJxaRHpTiI+7B3x1KDn2flE27bkezRkAwDQYJKoZIhvcNAQEBBQAE
# ggEAH5mfwf5eQ4FfKRBniT6CIWkFEZE06DueFhwYarV/zr6LIP86RRQnKrMSTKpx
# lNPbBEdSOvjpNx0+YjgcHFyPBZY55EFdqwFWPFm0xrpmJN8utfRvXNEDBBy/oNX2
# MQmegMj7g47A99rW0t8cBA/vu6vJe8hWMFBQN9np/Dxm5ROCV5HrVnzU1WLdOB/e
# jBUVKdDV4F7ZlXhS4fiMuZoA92HMIO1/aomoJy17cNFNubObq7Wii2/ir/qFKUFX
# 0P6okqc4GdtxFtojzQK4vUUVIdoh/iBdBJkl86dCyoFTHcNPsKYgLluDVI1usH6g
# 0RO9aEP6fKV0IFd0epl81zCZMA==
# SIG # End signature block
