import-module au

$release_url = 'https://github.com/mRemoteNG/mRemoteNG/releases/latest'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^[$]url\s*=\s*)('.*')"   = "`$1'$($Latest.Url)'"
        }
     }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $release_url -UseBasicParsing

    $re = '\.msi$'
    $url = $download_page.Links | ? href -match $re | select -first 1 -expand href | % { 'https://github.com' + $_ }

    $version32 = $url.Substring($url.LastIndexOf("-") + 1).Replace(".msi", "")

    @{
        URL = $url
        Version = $version32
    }
}

update -NoCheckUrl -ChecksumFor 32