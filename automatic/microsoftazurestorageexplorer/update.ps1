$ErrorActionPreference = 'Stop'
import-module au

$release_url = 'https://github.com/microsoft/AzureStorageExplorer/releases/latest'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^[$]url\s*=\s*)('.*')"   = "`$1'$($Latest.URL)'"
        }
     }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $release_url -UseBasicParsing

    $re = '\.exe$'
    $url = $download_page.Links | Where-Object href -match $re | Select-Object -first 1 -expand href | ForEach-Object { 'https://github.com' + $_ }

    $url_prefix = 'https://github.com/microsoft/AzureStorageExplorer/releases/download/v'
    $version32 = $url.ToLower().Replace($url_prefix.ToLower(), "").Split('/')[0]

    @{
        URL = $url
        Version = $version32
    }
}

update -NoCheckUrl -ChecksumFor 32