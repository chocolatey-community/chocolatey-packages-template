Import-Module au

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"           #1
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"      #2
        }
    }
}

function global:au_GetLatest {
    $releases = "https://desktop.docker.com/win/main/amd64/appcast.xml"
    [xml]$download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $enclosure = $download_page | Select-Xml -XPath "/rss/channel/item/enclosure" | select -Last 1
    $version = ($enclosure | Select-Xml -XPath "@sparkle:shortVersionString" -Namespace @{ sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" }).Node.Value

    $url = ($enclosure | Select-Xml -XPath "@d4w:url" -Namespace @{ d4w = "http://www.docker.com/docker-for-windows"  }).Node.Value

    @{ Version = $version; URL = $url }
}

update
