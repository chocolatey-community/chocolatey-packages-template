import-module au

$homepage = 'http://storageexplorer.com'
$url = 'http://go.microsoft.com/fwlink/?LinkId=708343'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }
     }
}

function global:au_GetLatest {
    $homepage_content = Invoke-WebRequest -Uri $homepage

    # Get Version
    $homepage_content -match '(Version \d+.\d+.\d+)'
    $version = $matches[1] -replace "Version ", ""

    $Latest = @{ URL = $url; Version = $version }
    return $Latest
}

update -ChecksumFor 32