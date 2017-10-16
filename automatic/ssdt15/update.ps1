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

	$link=$doc.GetElementsByTagName("a") | where {$_.innerText -like "*Download SSDT for Visual Studio 2015*"}
	Write-Host $link.href

	$temp_file = $env:TEMP + '\SSDTSetup.exe'
	Invoke-WebRequest $link.href -OutFile $temp_file
	Write-Host $temp_file

	$version = (Get-Command $temp_file).Version
	Write-Host $version

    $Latest = @{ URL = $link.href; Version = $version }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32