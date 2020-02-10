import-module au

$download_url = 'https://link.gotomeeting.com/minimum-build-msi'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.Url)'"
        }
    }
}

function global:au_GetLatest {
    $request = Invoke-WebRequest -Uri $download_url -MaximumRedirection 0 -ErrorAction Ignore

    $path = ([System.Uri]$request.Headers.Location).AbsolutePath

    $version = $path.SubString($path.LastIndexOf('/') + 1).TrimStart("G2MSetup").TrimEnd("_IT.msi")

    $Latest = @{ URL = $request.Headers.Location; Version = $version }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32