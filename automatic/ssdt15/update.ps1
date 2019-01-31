import-module au

$notes_url = 'https://docs.microsoft.com/en-us/sql/ssdt/download-sql-server-data-tools-ssdt'

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

    $notes_content = Invoke-WebRequest -Uri $notes_url

    $html = New-Object -Com "HTMLFile"
    $html.IHTMLDocument2_write($notes_content.content)
    $link = $html.getElementsByTagName("a") | where {$_.innerText -like "*Download SSDT for Visual Studio 2017*"}

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
