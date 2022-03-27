import-module au

$releases = 'https://github.com/Depressurizer/Depressurizer/releases'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*\`$packageName\s*=\s*)('.*')"  = "`$1'$($Latest.PackageName)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases

    $regex   = '/depressurizer-(.+?).zip'
    $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href
    $version = $Matches[1]
    @{
        URL32        = 'https://github.com' + $url
        Version      = $version
        ReleaseNotes = "https://github.com/Depressurizer/Depressurizer/releases/tag/v${version}"
    }
}

Update-Package