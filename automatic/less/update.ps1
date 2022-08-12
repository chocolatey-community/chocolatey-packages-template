import-module au

$releases = 'http://guysalias.tk/misc/less/'

function global:au_SearchReplace {
    @{
        ".\tools\VERIFICATION.txt" = @{
          "(?i)(\s+x32:).*"        = "`${1} $($Latest.URL32)"
          "(?i)(checksum32:).*"    = "`${1} $($Latest.Checksum32)"
        }
    }
}

function global:au_BeforeUpdate {
    set-alias 7z $Env:chocolateyInstall\tools\7z.exe

    $lessdir = "$PSScriptRoot\less-*-win*"
    rm $lessdir -Recurse -Force -ea ignore

    iwr $Latest.URL32 -OutFile "$PSScriptRoot\less.7z"
    7z x $PSScriptRoot\less.7z

    rm $PSScriptRoot\tools\* -Recurse -Force -Exclude VERIFICATION.txt
    mv $lessdir\* $PSScriptRoot\tools -Force
    rm $lessdir -Recurse -Force -ea ignore
    rm $PSScriptRoot\less.7z -ea ignore
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re  = 'less-.+win.+\.7z$'
    $url = $download_page.links | ? href -match $re | select -First 1 -expand href
    $version = "$( ($url -split '-' | select -Index 1) / 100 )"
    @{
       URL32   = $releases + $url
       Version = $version
    }
}

try {
    update -ChecksumFor none
} catch {
    $ignore = 'Unable to connect to the remote server'
    if ($_ -match $ignore) { Write-Host $ignore; 'ignore' }  else { throw $_ }
}
