import-module au

$releases = 'https://www.powershellgallery.com/packages/PowerShellForGitHub'

function global:au_SearchReplace {
    @{}
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $match = $download_page.Content | Select-String -Pattern '(href=.*PowerShellForGithub.*">)'
    $url = $match.Matches[0].value

    $version  = $url -split '[%2F]|" target="' | Select-Object -Last 1 -Skip 1

    @{
        Version = $version
    }
}

try {
    update -ChecksumFor all
} catch {
    $ignore = 'Unable to connect to the remote server'
    if ($_ -match $ignore) { Write-Host $ignore; 'ignore' }  else { throw $_ }
}
