import-module au

function global:au_SearchReplace
{
    @{
        "tools\chocolateyInstall.ps1" = @{
			"(^(\s)*url\s*=\s*)('.*')"        = "`$1'$($Latest.Url32)'"
            "(^(\s)*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^(\s)*url64\s*=\s*)('.*')"      = "`$1'$($Latest.Url64)'"
            "(^(\s)*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_GetLatest
{
    $releases = 'https://www.sws-extension.org/'
    $regex64 = 'sws-v(?<Version>[\d\.]+)-x64-install.exe$'
    $regex32 = 'sws-v(?<Version>[\d\.]+)-install.exe$'

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing	
    $url64 = $download_page.links | ? href -match $regex64 | Select-Object -First 1
    $url32 = $download_page.links | ? href -match $regex32 | Select-Object -First 1
    
    return @{ 
              Version = $matches.Version
              Url32 = $releases + $url32.href
              Url64 = $releases + $url64.href
            }
}

Update-Package
