import-module au

$feed_url = 'https://plex.tv/downloads/details/1?build=windows-i386&distro=english'

function global:au_BeforeUpdate() {
     $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url
 }

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^[$]url\s*=\s*)('.*')"   = "`$1'$($Latest.Url)'"
        }
     }
}

function global:au_GetLatest {
    Write-Host $feed_url

	[xml]$homepage_content = Invoke-WebRequest -UseBasicParsing -Uri $feed_url

	$version = $homepage_content.DocumentElement.SelectSingleNode("Release").Attributes["version"].Value.Split("-")[0]

	Write-Host $version

	$url = $homepage_content.DocumentElement.SelectSingleNode("Release").SelectSingleNode("Package").Attributes["url"].Value

	Write-Host $url

    $Latest = @{ URL = $url; Version = $version }
    return $Latest
}

update -NoCheckUrl -ChecksumFor None