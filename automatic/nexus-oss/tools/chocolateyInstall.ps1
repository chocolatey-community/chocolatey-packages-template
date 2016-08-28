$ErrorActionPreference = 'Stop'

$packageName = 'nexus-oss'
$url         = 'https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-2.13.0-01-bundle.zip'
$checksum    = '76E2A2904FF0341A5FB646F615E3724F6C54E8A71759A7F8F06F702339D0767B'
$installDir  = 'c:\nexus'

$packageArgs = @{
  packageName    = $packageName
  url            = $url
  url64Bit       = $url #url includes both 32-bit and 64-bit
  checksum       = $checksum
  checksum64     = $checksum
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = $installDir
}

if ($Env:ChocolateyPackageParameters -match '/InstallDir:\s*(.+)') {
    $installDir = $Matches[1]
    if ($installDir.StartsWith("'") -or $installDir.StartsWith('"')){  $installDir = $installDir -replace '^.|.$' }
    $parent = Split-Path $installDir
    mkdir -force $parent -ea 0 | out-null
}

if (gcm nexus -ea 0) {
    Write-Host "Detected existing installation, uninstalling service"
    0 | nexus stop
    0 | nexus uninstall
}

Write-Host "Installing to '$installDir'"
Install-ChocolateyZipPackage @packageArgs

$nexusDir = ls $installDir\nexus-* | sort -Descending | select -First 1
$nexus = "$nexusDir\bin\nexus.bat"
if (!(Test-Path $nexus)) { throw "Can not find nexus.bat" }
Install-BinFile nexus $nexus

0 | nexus install
0 | nexus start

$s = gsv nexus-webapp -ea 0
if (!$s) { throw "Nexus service 'nexus-webapp' is not installed" }
if ($s.Status -ne 'Running') { Write-Warning "Nexus service 'nexus-webapp' is installed but not running" }

$ok = $false
try {
    $request  = [System.Net.HttpWebRequest]::Create("http://localhost:8081/nexus")
    $response = $request.GetResponse()
    $ok = $response.StatusCode -eq 'OK'
} catch {}

if (!$ok) { Write-Warning "Nexus should be available at http://localhost:8081/nexus but can't be reached" }
else { Write-Host "Nexus is available at http://localhost:8081/nexus" }
