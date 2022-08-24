$ErrorActionPreference = 'Stop'
import-module au

$download_page_url = 'https://zoom.us/download#client_4meeting'
$url_part1 = 'https://cdn.zoom.us/prod/'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^[$]url\s*=\s*)('.*')"   = "`$1'$($Latest.Url32)'"
            "(^[$]checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
            "(^[$]url64\s*=\s*)('.*')"   = "`$1'$($Latest.Url64)'"
        }
     }
}
function global:au_BeforeUpdate {
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.URL32
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64
}

function global:au_GetLatest {
    $homepage_content = Invoke-WebRequest -Uri $download_page_url -UseBasicParsing

     # Get Version
    $homepage_content -match 'Version \d+\.\d+\.\d (\(\d+\))'| Out-Null
    $recodeversion = $matches[0] -replace "Version ", ""
    $version = $recodeversion.Replace(' ', '').Replace(')', '').Replace('(','.')
    $url32 = $url_part1 + $version + '/ZoomInstallerFull.msi'
    $url64 = $url_part1 + $version + '/x64/ZoomInstallerFull.msi'

    $Latest = @{ URL32 = $url32; URL64=$url64; Version = $version }
    return $Latest
}

update -ChecksumFor none