Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$details_url = 'https://www.microsoft.com/en-us/download/details.aspx?id=46899'
$download_page_url = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=46899'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $download_page_url -UseBasicParsing

  $Url32 = $download_page.Links | Where-Object {$_.href -like "*LAPS.x86.msi*"} | Select-Object -ExpandProperty href -First 1
  $Url64 = $download_page.Links | Where-Object {$_.href -like "*LAPS.x64.msi*"} | Select-Object -ExpandProperty href -First 1
  $ChecksumType = 'sha256'

  #region Get Version
  $details = Invoke-WebRequest -Uri $details_url -UseBasicParsing

  $re = 'Version:(.*?)((\d+)\.(\d+))'
  $details -match $re | Out-Null
  $version = $Matches[2]
  #endregion

  @{
    Url32             = $Url32
    Url64             = $Url64
    Version           = $version
    ChecksumType32    = $ChecksumType
    ChecksumType64    = $ChecksumType
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32 -Algorithm $Latest.ChecksumType32
  $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64 -Algorithm $Latest.ChecksumType64
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.Url32)'"
          "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
          "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
          "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.Url64)'"
          "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
          "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
      }
  }
}

Update-Package -ChecksumFor none
