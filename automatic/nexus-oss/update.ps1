import-module au

$url = 'http://www.sonatype.org/downloads/nexus-latest-bundle.zip'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"       = "`$1'$($Latest.URL)'"
            "(^[$]checksum\s*=\s*)('.*')"  = "`$1'$($Latest.Checksum32)'"
        }
     }
}

function global:au_GetLatest {
    while($true) {
        $request = [System.Net.WebRequest]::Create($url)
        $request.AllowAutoRedirect=$false
        $response=$request.GetResponse()
        $location = $response.GetResponseHeader('Location')
        if (!$location -or ($location -eq $url)) { break }
        $url = $location
    }

    $version = ($url -split '-|\.' | select -Last 4 -skip 2) -join '.'
    $Latest = @{ URL = $url; Version = $version }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32
