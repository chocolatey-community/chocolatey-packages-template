import-module au

$download_page_url = 'https://link.gotomeeting.com/minimum-build-msi'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^[$]url\s*=\s*)('.*')"   = "`$1'$($Latest.Url)'"
        }
     }
}

function global:au_GetLatest {
    $content = Invoke-WebRequest -UseBasicParsing -Uri $download_page_url

    $content -match '<title>GoToMeeting MSI Installer - \d+.\d+.\d+.\d+'| Out-Null
    $version = $matches[0] -replace "<title>GoToMeeting MSI Installer - ", ""

    $re = '\.zip$'
    $url = $content.Links | ? href -match $re | select -first 1 -expand href

    $Latest = @{ URL = $url; Version = $version }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32