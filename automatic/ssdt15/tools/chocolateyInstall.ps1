$checksum = 'C287010E7AEF0D4AB00960FA6B6308DAE5514A7172DA539F7CD7A4176A7C6327'
$url = 'https://download.microsoft.com/download/D/9/9/D994CE20-DE0D-494B-BAA0-C3FC20E5E989/Dev14/EN/SSDTSetup.exe'

(Get-WmiObject -Class Win32_OperatingSystem).Version -match "(?<Major>\d+).(?<Minor>\d+).(?<Build>\d+)" | Out-Null
 
if ($Matches.Major -eq 6 -and $Matches.Minor -eq 3)
{
    # Windows 8.1 / Server 2012 R2 requires a prerequisite hotfix 
    if (-not (Get-HotFix -Id KB2919355 -ErrorAction SilentlyContinue))
    {
        Write-Error "A prerequisite for installing SQL Server Data Tools for Visual Studio 2015 on Windows 8.1 and Windows Server 2012 R2 is to have hotfix KB2919355 installed. See https://msdn.microsoft.com/library/ms143506.aspx for more details"
    }
}

$packageArgs = @{
  packageName   = 'ssdt15'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = $url
  silentArgs    = '/passive /norestart'
  validExitCodes= @(0)
  softwareName  = 'ssdt15*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs