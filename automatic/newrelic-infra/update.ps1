import-module au

$releases = 'https://nr-downloads-main.s3.amazonaws.com/?delimiter=/&prefix=infrastructure_agent/windows/'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^[$]packageName\s*=\s*)('.*')"  = "`$1'$($Latest.PackageName)'"
            "(?i)(^[$]softwareName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)*'"
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

    $match = $download_page.Content | Select-String -Pattern '(windows/.*newrelic-infra.*\.msi)'
    $url_suffix = $match.Matches[0].value
    
    $system_version = $url_suffix -split '[_-]infra\.|.msi' | Select-String ^\d*\.\d*\.\d*$ | %{ new-object System.Version ($_) } | Sort-Object | Select-Object -Last 1
    $version = "$($system_version.Major).$($system_version.Minor).$($system_version.Build)"
    $url = "https://download.newrelic.com/infrastructure_agent/windows/newrelic-infra.$($version).msi"


    @{
        Version      = $version
        URL64        = $url
        ReleaseNotes = 'https://docs.newrelic.com/docs/release-notes/infrastructure-release-notes/infrastructure-agent-release-notes'
    }
}

try {
    update -ChecksumFor 64
} catch {
    $ignore = 'Unable to connect to the remote server'
    if ($_ -match $ignore) { Write-Host $ignore; 'ignore' }  else { throw $_ }
}
