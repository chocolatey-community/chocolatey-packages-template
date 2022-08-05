import-module au

$releases = 'https://github.com/dnGrep/dnGrep/releases'

function global:au_BeforeUpdate {
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.URL32 -Algorithm $Latest.ChecksumType32
  }

function global:au_SearchReplace {
    @{
       ".\legal\VERIFICATION.txt" = @{
          "(?i)(\s+x32:).*"            = "`${1} $($Latest.URL32)"
          "(?i)(\s+x64:).*"            = "`${1} $($Latest.URL64)"
          "(?i)(checksum32:).*"        = "`${1} $($Latest.Checksum32)"
          "(?i)(checksum64:).*"        = "`${1} $($Latest.Checksum64)"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
     }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }
function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re      = 'dnGREP.*.msi'
    $url     = $download_page.links | ? href -match $re | select -First 2 -expand href
    $url64   = 'https://github.com' + $url[0]
    $url32   = 'https://github.com' + $url[1]
    $version = $url[0] -split '\/' | select -Index 5
    $Latest = @{ URL32 = $url; Version = $version; ChecksumType32 = 'sha512' }

    return @{
        Version = $version.Substring(1)
        URL32 = $url32
        URL64 = $url64
        ReleaseNotes = "https://github.com/dnGrep/dnGrep/releases/tag/$version"
        Latest = $Latest
    }

    @{
        URL32          = $url32 -replace '^http:', 'https:'
        URL64          = $url64 -replace '^http:', 'https:'
        Version        = $version32
        ChecksumType32 = 'sha512'
        ChecksumType64 = 'sha512'
      }
}

update -ChecksumFor none