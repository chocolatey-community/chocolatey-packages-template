import-module au

function global:au_SearchReplace
{
    @{
        "tools\chocolateyInstall.ps1" = @{
			"(^(\s)*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"            
        }
    }
}

function global:au_GetLatest
{
    $releases = 'http://updates.guitar-pro.com/gp7/?os=win32&channel=stable'
    $regex = 'Version (?<Version>[\d\.]+)$'
    
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing	
    $title_node = $download_page | Select-Xml -XPath '/rss/channel/item/title'
    $versionFound = $title_node -match $regex

    # URL stays the same, XML provides only incremental update which is not suitable for new installations
    return @{ 
              Version = $matches.Version              
            }
}

Update-Package
