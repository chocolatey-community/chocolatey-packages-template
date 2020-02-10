$ErrorActionPreference = 'Stop'
import-module au

$url = 'http://go.microsoft.com/fwlink/?LinkId=708343'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }
     }
}

function global:au_GetLatest {
    $temp_file = $env:TEMP + '\StorageExplorer.exe'
    Invoke-WebRequest $url -OutFile $temp_file
    Write-Host $temp_file

    $version = ([version](dir $temp_file).VersionInfo.ProductVersion)
    Write-Host $version


    $Latest = @{ URL = $url; Version = $version }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32
