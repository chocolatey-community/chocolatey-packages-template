Import-Module au
$download_scrape_url     = "https://www.microsoft.com/en-us/edge/business/download"
$download_scrape_version = "Stable"

$artifact_base_url       = "https://www.microsoft.com/en-us/edge/business/Product/GetArtifacturl"
$artifact_arch32         = "x86"
$artifact_arch64         = "x64"

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url64\s*=\s*)('.*')"              = "`$1'$($Latest.URL64)'"
      "(^[$]url32\s*=\s*)('.*')"              = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
    }
   }
}

function global:au_GetLatest {
  # get contents of the download page (HTML)
  $download_scrape_content = Invoke-WebRequest -Uri $download_scrape_url
  
  # grab the JSON containing all version/download information
  $json_node = ($download_scrape_content.AllElements | ? {$_.id -eq 'commercial-json-data'} | select -first 1)
  $json_data = $json_node.'data-whole-json' | ConvertFrom-Json
  
  # select the release version (Dev/Beta/Stable)
  $download_url_data = $json_data | ? {$_.Product -eq $download_scrape_version}
  
  # select the first version per architecture from the JSON - this should be the latest version
  $download_32_data = $download_url_data.Releases | ? {$_.Architecture -eq $artifact_arch32 -and $_.Platform -eq "Windows"} | select -first 1
  $download_64_data = $download_url_data.Releases | ? {$_.Architecture -eq $artifact_arch64 -and $_.Platform -eq "Windows"} | select -first 1
  $download_url_32 = $download_32_data.Artifacts[0].Location
  $download_hash_32 = $download_32_data.Artifacts[0].Hash
  $download_url_64 = $download_64_data.Artifacts[0].Location
  $download_hash_64 = $download_64_data.Artifacts[0].Hash
    
  $version_number = $download_32_data.ProductVersion.Trim()
  
  $Latest = @{URL32 = $download_url_32; URL64 = $download_url_64; Version = $version_number; Checksum32 = $download_hash_32; Checksum64 = $download_hash_64;}
  return $Latest
}

update