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
    $baseUrl = 'http://oblique-audio.com/'
    $releases = $baseUrl + 'rtl-utility.php'
    $regex32 = '/RTL_Utility_(?<Version>[\d_]+)_Win32.exe$'
    $regex64 = '/RTL_Utility_(?<Version>[\d_]+)_x64.exe$'

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing	
    $url32 = $download_page.links | ? href -match $regex32 | Select-Object -First 1
    $url64 = $download_page.links | ? href -match $regex64 | Select-Object -First 1
    
    return @{ 
              Version = $matches.Version -replace "_", "."
              Url32 = $baseUrl + $url32.href
              Url64 = $baseUrl + $url64.href
            }
}

Update-Package
