#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
import-module au
. $PSScriptRoot\..\_scripts\all.ps1

$SemVerRegexWithCaptures = '(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?'

$VersionPrefixLatest = '7.2.\d+'
$VersionPrefixLTS = '7.0.\d+'
$VersionPrefixPreview = "7.3"

#find preview prefix if one exists
#if ([regex]::Match($version_preview,"-([a-z]*)").success) {  $previewprefix = "$([regex]::Match($version_preview,"-([a-z]*)").captures.groups[1].value)" }
$previewprefix = 'rc'

$releases    = 'https://github.com/PowerShell/PowerShell/releases'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]Version\s*=\s*)('.*')"= "`$1'$($Latest.Version)'"
            "(?i)(^\s*[$]packageName\s*=\s*)('.*')"= "`$1'$($Latest.PackageName)'"
            "(?i)(^\s*[$]fileType\s*=\s*)('.*')"   = "`$1'$($Latest.FileType)'"
            "(?i)(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*url64\s*=\s*)('.*')"        = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"           
        }

        ".\legal\VERIFICATION.txt" = @{
          "(?i)(\s+x32:).*"            = "`${1} $($Latest.URL32)"
          "(?i)(checksum32:).*"        = "`${1} $($Latest.Checksum32)"
          "(?i)(\s+x64:).*"            = "`${1} $($Latest.URL64)"
          "(?i)(checksum64:).*"        = "`${1} $($Latest.Checksum64)"
        }
       ".\powershell-core.nuspec" = @{
           "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
       }        
    }
}

#function global:au_BeforeUpdate { Get-RemoteFiles -Purge }
function global:au_AfterUpdate  { Set-DescriptionFromReadme -SkipFirst 2 }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases

    #Latest
    $re  = "PowerShell-$VersionPrefixLatest-win-x64.msi"
    $url = $download_page.links | ? href -match $re | select -First 1 -expand href
    $url = "https://github.com" + $url
    $url32 = $url -replace 'x64.msi$', 'x86.msi'  
    $url -match $SemVerRegexWithCaptures
    $version = $matches[0]

    #LTS
    $re_LTS  = "PowerShell-$VersionPrefixLTS-win-x64.msi"
    $url_LTS = $download_page.links | ? href -match $re_LTS | select -First 1 -expand href
    $url_LTS = "https://github.com" + $url_LTS
    $url32_LTS = $url_LTS -replace 'x64.msi$', 'x86.msi'  
    $url_LTS -match $SemVerRegexWithCaptures
    $version_LTS = $matches[0]
    
#    #Preview
#    $re_Preview  = "*PowerShell-$VersionPrefixPreview*${previewprefix}-win-x64.msi*"
#    $url_Preview = $download_page.links | ? href -ilike $re_Preview | select -First 1 -expand href
#    $url_Preview = "https://github.com" + $url_Preview
#    $url32_Preview = $url_Preview -replace 'x64.msi$', 'x86.msi'  
#    $url_Preview -match $SemVerRegexWithCaptures
#    $version_Preview = $matches[0]

    #Zero pad prereleases that are two digits so they sort correctly in case we go over 9
    #if (([regex]::Match($version_preview,"-${previewprefix}.([\d*])").captures.groups[1].length) -lt 2) { $version_Preview = $version_Preview -replace "-${previewprefix}.", "-${previewprefix}0" };  
    
    return @{
      Streams = [ordered] @{
	    	'Latest' = @{        
          URL64        = $url;
          URL32        = $url32;
          Version      = $version;
          ReleaseNotes = "$releases/tag/${version}";
          PackageName = 'powershell-core';
        }
	    	'LTS' = @{        
          URL64        = $url_LTS;
          URL32        = $url32_LTS;
          Version      = $version_LTS;
          ReleaseNotes = "$releases/tag/${version_LTS}";
          PackageName = 'powershell-core';
        } 
            
    }
  }
}

#	    	'Preview' = @{        
#          URL64        = $url_Preview;
#          URL32        = $url32_Preview;
#          Version      = $version_Preview -replace "-$previewprefix.", "-$previewprefix" -replace ' ', '';
#          ReleaseNotes = "$releases/tag/${version_Preview}";
#          PackageName = 'powershell-core';
#        }

update
