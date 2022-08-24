Import-Module au

$releases = 'https://api.github.com/repos/microsoft/terminal/releases'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function CreateStream {
  param($url32bit, $version)

  $Result = @{
    Version       = $version
    URL32         = $url32bit
    RemoteVersion = $version -replace '-beta'
    PreRelease    = $version -like "*-beta"
    FileType      = 'msixbundle'
  }

  return $Result
}


function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }
  $download_page = Invoke-RestMethod -Uri $releases -UseBasicParsing -Headers $header

  $streams = @{ }

  $regexes = @(
    "Microsoft.WindowsTerminal"
    "Microsoft.WindowsTerminalPreview"
  )

  foreach($re in $regexes) {
    foreach ($release in $download_page) {
      Clear-Variable -Name "asset" -ErrorAction SilentlyContinue
      $fileVersion = $release.tag_name.Replace('v', '')
      $version = $release.tag_name.Replace('v', '')
      if ($release.prerelease -and $re -like "*Preview") {
        $version += '-beta'
      }

      $version = Get-Version $version
      $asset = $release.assets | Where-Object -Property name -like "${re}_*.msixbundle" | Where-Object -Property name -Match $fileVersion
      if ($asset) {
        $url = $asset.browser_download_url
        $streams.Add($re, (CreateStream $url $version))
        break
      }
    }
  }

  return @{ Streams = $streams }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]fileName\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName32)`""
      "(^[$]version\s*=\s*)`".*`""             = "`${1}`"$($Latest.RemoteVersion)`""
      "(^[$]PreRelease\s*=\s*)`".*`""             = "`${1}`"$($Latest.PreRelease)`""
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}