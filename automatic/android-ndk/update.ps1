import-module au

$releases = 'https://developer.android.com/ndk/downloads'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^[$]packageName\s*=\s*)('.*')"  = "`$1'$($Latest.PackageName)'"
            "(?i)(^[$]softwareName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)*'"
            "(?i)(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(checksum\s*=\s*)('.*')"             = "`$1'$($Latest.Checksum32)'"
            "(?i)(^[$]url64\s*=\s*)('.*')"        = "`$1'$($Latest.URL64)'"
            "(checksum64\s*=\s*)('.*')"           = "`$1'$($Latest.Checksum64)'"
        }

        ".\tools\chocolateyUninstall.ps1" = @{
            "(?i)(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(?i)(^[$]url64\s*=\s*)('.*')"        = "`$1'$($Latest.URL64)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $match = $download_page.Content | Select-String -Pattern '(android-ndk-.*-windows-.*\.zip)'
    $url = "https://dl.google.com/android/repository/$($match.Matches[0].value)"
    
    $rawVersion  = $url -split '[_-]|.zip' | Select-Object -Last 1 -Skip 3
    $rawVersion = $rawVersion.Replace('r','')

    If($rawVersion -as [int]){
        $version = "$rawVersion.0"
    } Else {
        # If version include alphabetical minor version, convert it to integer
        $result = $rawVersion -match '(\d+)(\D+)'
        $majorVersion = $matches[1]
        $minorVersion = $matches[2]
    
        $minorVersionInt = [int][char]$minorVersion % 32;
        $version = "$majorVersion.$minorVersionInt"
    }

    @{
        Version      = $version
        URL32        = $url
        URL64        = $url -replace 'x86','x86_64'
        ReleaseNotes = 'https://developer.android.com/ndk/downloads/revision_history'
    }
}

try {
    update -ChecksumFor all
} catch {
    $ignore = 'Unable to connect to the remote server'
    if ($_ -match $ignore) { Write-Host $ignore; 'ignore' }  else { throw $_ }
}
