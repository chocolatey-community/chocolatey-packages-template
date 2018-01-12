import-module au

$releases = 'https://portal.influxdata.com/downloads'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^[$]packageName\s*=\s*)('.*')"  = "`$1'$($Latest.PackageName)'"
            "(?i)(^[$]softwareName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)*'"
            "(?i)(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(checksum\s*=\s*)('.*')"             = "`$1'$($Latest.Checksum32)'"
            "(?i)(^[$]url64\s*=\s*)('.*')"        = "`$1'$($Latest.URL64)'"
            "(checksum64\s*=\s*)('.*')"           = "`$1'$($Latest.Checksum64)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $match = $download_page.Content | Select-String -Pattern '(https:.*telegraf.*\.zip)'
    $url = $match.Matches[0].value
    
    $version  = $url -split '[_-]|.zip' | Select-Object -Last 1 -Skip 3

    @{
        Version      = $version
        URL32        = $url -replace 'amd64','i386'
        URL64        = $url
        ReleaseNotes = 'https://github.com/influxdata/telegraf/blob/master/CHANGELOG.md'
    }
}

try {
    update -ChecksumFor all
} catch {
    $ignore = 'Unable to connect to the remote server'
    if ($_ -match $ignore) { Write-Host $ignore; 'ignore' }  else { throw $_ }
}
