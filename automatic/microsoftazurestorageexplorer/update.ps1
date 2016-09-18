import-module au

$homepage = 'http://storageexplorer.com'
$url = 'http://go.microsoft.com/fwlink/?LinkId=708343'
$filename = 'StorageExplorer.exe'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum)'"
        }
     }
}

function global:au_GetLatest {
    Write-Host 'Start'
    $homepage_content = Invoke-WebRequest -Uri $homepage
    Write-Host 'Context downloaded'
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

update