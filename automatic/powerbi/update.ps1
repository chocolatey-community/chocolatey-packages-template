Import-module au

function global:au_GetLatest {
   $MainURL = 'https://powerbi.microsoft.com/en-us/desktop/'
   $MainPage = Invoke-WebRequest -Uri $MainURL
   $DownloadURL = $MainPage.links | ? {$_.innertext -match 'language options'} | select -ExpandProperty href
   $DownloadPage = Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing
   $version = $DownloadPage -split '</?p>' | ? {$_ -match '^[0-9.]+$'}

   $ID = ($downloadpage.rawcontent.split('"') |? {$_ -match 'confirmation'} |select -first 1) -replace '.*id=(\d+).*','$1'

   $UID = ($downloadpage.rawcontent.split('"') |? {$_ -match "$ID&"} |select -first 1) -replace '.*amp;([0-9a-f-]+).*','$1'

   $confirmURL = "https://www.microsoft.com/en-us/download/confirmation.aspx?id=$ID&amp;$UID=1"

   $confirmpage = Invoke-WebRequest $confirmURL -UseBasicParsing

   $URL32 = $confirmpage.rawcontent.split('"') | ? {$_ -match 'setup.exe$'} | select -first 1
   $url64 = $confirmpage.rawcontent.split('"') | ? {$_ -match 'x64.exe$'} | select -first 1

   return @{ 
            Version  = $Version
            URL32    = $URL32
            URL64    = $URL64
           }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

Update-Package -ChecksumFor all