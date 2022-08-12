import-module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases    = 'https://github.com/hluk/CopyQ/releases'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]packageName\s*=\s*)('.*')"= "`$1'$($Latest.PackageName)'"
            "(?i)(^\s*[$]fileType\s*=\s*)('.*')"   = "`$1'$($Latest.FileType)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }

        ".\legal\VERIFICATION.txt" = @{
          "(?i)(\s+x32:).*"            = "`${1} $($Latest.URL32)"
          "(?i)(checksum32:).*"        = "`${1} $($Latest.Checksum32)"
          "(?i)(Get-RemoteChecksum).*" = "`${1} $($Latest.URL32)"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }
function global:au_AfterUpdate  { Set-DescriptionFromReadme -SkipFirst 2 }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases

    $re  = "copyq-.*-setup.exe"
    $url = $download_page.links | ? href -match $re | select -First 1 -expand href
    $url = 'https://github.com' + $url

    $version = $url -split '-|.exe' | select -Last 1 -Skip 2

    return @{
        URL32        = $url
        Version      = $version.Replace('v','')
        ReleaseNotes = "$releases/tag/${version}"
    }
}

update -ChecksumFor none
