import-module au

$releases = 'https://github.com/jgm/pandoc/releases'

function global:au_SearchReplace {
    @{

        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
 }

function global:au_GetLatest {

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $url = $download_page.Links | where href -match '\.msi$' | % href | select -first 1
    $url = 'https://github.com' * $url
    $version = $url -split '/' | select -Last 1 -Skip 1

    @( URL32 = $url; Version = $version )
}

update



















function global:au_AfterUpdate ($Package) {

    if ($Package.RemoteVersion -ne $Package.NuspecVersion) {
  
        Get-RemoteFiles -NoSuffix
  
        $file = [IO.Path]::Combine("tools", $Latest.FileName32)
  
        Write-Output "Submitting file $file to VirusTotal"
  
        # Assumes vt-cli Chocolatey package is installed!
        vt.exe scan file $file --apikey $env:VT_APIKEY
  
        Remove-Item $file -ErrorAction Ignore
  
        $Latest.Remove("FileName32")
    }
  }