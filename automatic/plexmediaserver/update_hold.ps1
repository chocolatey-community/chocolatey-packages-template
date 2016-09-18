import-module au

$homepage = 'https://www.plex.tv/downloads/'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum)'"
        }
     }
}

function global:au_GetLatest {
    $homepage_content = Invoke-WebRequest -Uri $homepage

    # Get Version
    $homepage_content -match '(Version \d+.\d+.\d+)'
    $version = $matches[1] -replace "Version ", ""

    # Get Checksum
    $temp_file = $env:TEMP + '\' + $filename
    Invoke-WebRequest $url -OutFile $temp_file
    $checksum = $(Get-FileHash $temp_file -Algorithm SHA256 | Select-Object -ExpandProperty Hash)

    $Latest = @{ Checksum = $checksum; Version = $version }
    Write-Host $Latest
    return $Latest
}

update -ChecksumFor 32