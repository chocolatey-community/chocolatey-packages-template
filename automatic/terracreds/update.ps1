import-module au

$releases = 'https://github.com/tonedefdev/terracreds/releases/'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL)'"
            "(checksum\s*=\s*)('.*')"             = "`$1'$($Latest.Checksum64)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $match = $download_page.Content | Select-String -Pattern '(download/.*terracreds.*windows_amd64\.zip)'
    $url_suffix = $match.Matches[0].value

    $system_version = ($url_suffix -split '[_-]|[_-]windows_amd64\.|.zip') -match "^\d*\.\d*\.\d*$" | %{ new-object System.Version ($_) } | Sort-Object | Select-Object -Last 1
    $version = "$($system_version.Major).$($system_version.Minor).$($system_version.Build)"
    $url = "https://github.com/tonedefdev/terracreds/releases/download/v$($version)/terracreds_$($version)_windows_amd64.zip"


    @{
        Version      = $version
        URL          = $url
        ReleaseNotes = 'https://github.com/tonedefdev/terracreds/releases'
    }
}

try {
    update -ChecksumFor 64
} catch {
    $ignore = 'Unable to connect to the remote server'
    if ($_ -match $ignore) { Write-Host $ignore; 'ignore' }  else { throw $_ }
}
