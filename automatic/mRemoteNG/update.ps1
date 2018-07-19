import-module au

$release_url = 'https://github.com/mRemoteNG/mRemoteNG/releases/latest'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
			"(^[$]url\s*=\s*)('.*')"   = "`$1'$($Latest.Url)'"
        }
     }
}

function global:au_GetLatest {
    Write-Host $release_url

	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	$page = Invoke-WebRequest $release_url
	$html = $page.parsedHTML

	$release_downloads = $html.body.getElementsByTagName("div") | where {$_.className -like "*label-latest*"}
	$downloadUrl = $release_downloads.getElementsByTagName("a") | where {$_.href -like "*.msi"}
	$url = $downloadUrl.href.Replace("about:", "https://github.com")
	Write-Host $url

	$version = $url.Substring($url.LastIndexOf("-") + 1).Replace(".msi", "")
	Write-Host $version

    $Latest = @{ URL = $url; Version = $version }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32