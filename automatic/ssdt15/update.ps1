import-module au

$notes_url = 'https://msdn.microsoft.com/en-us/mt186501'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
			"(^[$]url\s*=\s*)('.*')"   = "`$1'$($Latest.Url)'"
        }
     }
}

function global:au_GetLatest {
    Write-Host $notes_url

	$ie=New-Object -ComObject InternetExplorer.Application
	$ie.Navigate($notes_url)
	while ($ie.busy -eq $true) {
		Start-Sleep -Milliseconds 600
	}
	$doc=$ie.Document

	$elements=$doc.GetElementsByTagName("p") | where {$_.innerText -like "*Version:*"}

	$version = $elements.innerHTML.Replace("Version: ", "").Trim()
	Write-Host $version

	$elements=$doc.GetElementsByTagName("a") | where {$_.innerText -like "*Download SQL Server Data Tools*"}
	$url = $elements.href.Trim()
	Write-Host $url

    $Latest = @{ URL = $url; Version = $version }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32