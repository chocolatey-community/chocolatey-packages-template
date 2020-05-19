import-module au

function global:au_SearchReplace
{
    @{
        "tools\chocolateyInstall.ps1" = @{
			"(^(\s)*url\s*=\s*)('.*')"        = "`$1'$($Latest.Url32)'"
            "(^(\s)*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"            
        }
    }
}

function global:au_GetLatest
{
    $releases = 'https://www.qnap.com/en/utilities/essentials'    
    $regex32 = 'QNAPQsyncClientWindows-(?<Version>[\d\.]+).exe$'

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing	
    $url32 = $download_page.links | ? href -match $regex32 | Select-Object -First 1
    
    return @{ 
              Version = $matches.Version
              Url32 = $url32.href              
            }
}

Update-Package
