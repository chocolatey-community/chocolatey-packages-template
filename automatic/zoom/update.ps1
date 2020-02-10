$ErrorActionPreference = 'Stop'
import-module au

$download_page_url = 'https://zoom.us/download#client_4meeting'
$url_part1 = 'https://zoom.us/client/'
$url_part2 = '/ZoomInstallerFull.msi'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^[$]url\s*=\s*)('.*')"   = "`$1'$($Latest.Url)'"
        }
     }
}

function global:au_GetLatest {
    $homepage_content = Invoke-WebRequest -UseBasicParsing -Uri $download_page_url

     # Get Version
    $homepage_content -match '(Version \d+.\d+.\d (\(.\d+.\d+\)))'| Out-Null
    $recodeversion = $matches[1] -replace "Version ", ""
    $version = $recodeversion.Substring(0,4) + $recodeversion.Substring(7,9)
    $url = $url_part1 + $version + $url_part2
    

    $Latest = @{ URL = $url; Version = $version }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32
