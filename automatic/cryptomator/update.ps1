import-module au

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*url64bit\s*=\s*)('.*')"     = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*packageName\s*=\s*)('.*')"  = "`$1'$($Latest.PackageName)'"
            "(?i)(^\s*fileType\s*=\s*)('.*')"     = "`$1'$($Latest.FileType)'"
        }
    }
}

function global:au_GetLatest {

    # getting the latest version via bintray
    $base_uri = 'https://api.bintray.com'
    $account = $repository = 'cryptomator'
    $package = 'cryptomator-win'
    $url = "$base_uri/packages/$account/$repository/$package" + "?attribute_values=1"
    $packageDetails = Invoke-WebRequest $url
    if ($packageDetails.StatusCode -eq 200)
    {
        # use regex to only select versions that include 3 groups of digits separated by dots (this avoids releases that end with -rc or similiar)
        $regex = '^(\d+\.)?(\d+\.)?(\*|\d+)$'
        # get the latest version that matches
        $version = ($packageDetails.Content | ConvertFrom-Json).Versions | Where-Object {$_ -match $regex} | Select-Object -first 1
        $url32   = "https://bintray.com/cryptomator/cryptomator/download_file?file_path=Cryptomator-$version-x86.exe"
        $url64   = "https://bintray.com/cryptomator/cryptomator/download_file?file_path=Cryptomator-$version-x64.exe"

        @{ URL32 = $url32; URL64=$url64; Version = $version }
    }

}

Update-Package