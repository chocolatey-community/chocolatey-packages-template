import-module au

$releases = 'https://github.com/jgm/pandoc/releases'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
    }
 }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    
    $url = $download_page.Links | where href -match '\.msi$' | % href | select -first 1
    
    $version = $url -split '/' | select -Last 1 -Skip 1
    $version = Get-Version($version)

    $url = "https://github.com/jgm/pandoc/releases/" + $version

    $Latest = @{ URL64 = $url; Version = $version }
    return $Latest
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 64
}
