import-module au

$releases = 'https://teams.microsoft.com/downloads'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # 32bit
    $download_page = Invoke-WebRequest -Uri "https://teams.microsoft.com/downloads/DesktopUrl?env=production&plat=windows"

    #https://statics.teams.cdn.office.net/production-windows/1.4.00.7174/TeamsSetup.exe
    
    $url32 = $download_page.Content.Trim()

    $url32 -match ".*\/(?<version>\d+\.\d+\.\d+\.\d+)\/TeamsSetup\.exe"

    $version = $Matches.version

    $download_page = Invoke-WebRequest -Uri "https://teams.microsoft.com/downloads/DesktopUrl?env=production&plat=windows&arch=x64"
    
    $url64 = $download_page.Content.Trim()

    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
    return $Latest
}

update