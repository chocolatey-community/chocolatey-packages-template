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
    $baseUrl = 'https://github.com'
    $releases = $baseUrl + '/lindell/multi-gitter/releases/latest'
    $regex32 = 'multi-gitter/releases/download/v(?<Version>[\d\.]+)/multi-gitter_(?<Version>[\d\.]+)_Windows_i386.tar.gz$'
    $regex64 = 'multi-gitter/releases/download/v(?<Version>[\d\.]+)/multi-gitter_(?<Version>[\d\.]+)_Windows_x86_64.tar.gz$'

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing	
    $url32 = $download_page.links | ? href -match $regex32 | Select-Object -First 1
    $url64 = $download_page.links | ? href -match $regex64 | Select-Object -First 1
    
    return @{ 
              Version = $matches.Version
              Url32 = $baseUrl + $url32.href
              Url64 = $baseUrl + $url64.href
            }
}

Update-Package
