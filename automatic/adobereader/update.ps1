import-module au

function global:au_GetLatest {
   # Discover the latest release version
   $VersionURL  = 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html'
   $download_page = Invoke-WebRequest -UseBasicParsing -Uri $VersionURL #-UseBasicParsing -DisableKeepAlive
   $ReleaseText = $download_page.links | 
                     Where-Object {$_.innertext -match 'DC.*\([0-9.]+\)'} |
                     Select-Object -ExpandProperty innertext -First 1
   $Release = $ReleaseText -replace '.*\(([0-9.]+)\).*','$1'
   $version = "20$Release"
   $ReleaseFolder = $Release.replace('.','')

   # Find the MSP for the latest version
   $FTPbase = 'ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC'
   $MSPpage = Invoke-WebRequest -Uri "$FTPbase/$ReleaseFolder" -DisableKeepAlive
   $MUIMSPstub = $MSPpage.rawcontent -split '"' |
                  Where-Object {$_ -match 'MUI\.msp$'} |
                  Select-Object -First 1
   $MSPstub = $MSPpage.rawcontent -split '"' |
                  Where-Object {$_ -match '\d\.msp$'} |
                  Select-Object -First 1

   # Find the most-recent EXE
   $FTPpage = Invoke-WebRequest -Uri $FTPbase -DisableKeepAlive
   $Folders = $FTPpage.rawcontent -split '[\r\n]' | 
                  Where-Object {$_ -match '>\d+<'} |
                  ForEach-Object {$_ -replace '.*>(\d+)<.*','$1'} |
                  Sort-Object -Descending
   foreach ($folder in $Folders) {
      $FolderFiles = Invoke-WebRequest -Uri "$FTPbase/$folder" -DisableKeepAlive
      $EXEstub = $FolderFiles.rawcontent -split '"' |
                     Where-Object {$_ -match 'en_US\.exe$'} |
                     Select-Object -First 1
      if ($EXEstub) { break }
   }
   $MUIstub = $EXEstub -replace 'en_US','MUI'

   return  @{ 
       Version   = $version
       URL32     = "http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/$MUIstub"
       MUIMSPurl = "$FTPbase/$MUIMSPstub"
   }
}

function global:au_SearchReplace {
   @{
      'tools\chocolateyInstall.ps1' = @{
         "(^[$]MUIurl\s*=\s*)('.*')"         = "`$1'$($Latest.URL32)'"
         "(^[$]MUIchecksum\s*=\s*)('.*')"    = "`$1'$($Latest.Checksum32)'"
         "(^[$]MUImspURL\s*=\s*)('.*')"      = "`$1'$($Latest.MUIMSPurl)'"
         "(^[$]MUImspChecksum\s*=\s*)('.*')" = "`$1'$($Latest.MUImspChecksum)'"
      } 
   }
}

function global:au_BeforeUpdate() {
   $Latest.MUImspChecksum = Get-RemoteChecksum $Latest.MUIMSPurl
}

Update-Package -NoCheckChocoVersion

