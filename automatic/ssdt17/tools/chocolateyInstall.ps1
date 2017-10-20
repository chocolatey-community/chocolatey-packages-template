$checksum = 'b9cad935be8613aa02c5251d32b05433a2dadf2284d03eb4afa8ca4f81e9036c'
$url = 'https://go.microsoft.com/fwlink/?LinkID=832313'

(Get-WmiObject -Class Win32_OperatingSystem).Version -match "(?<Major>\d+).(?<Minor>\d+).(?<Build>\d+)" | Out-Null
 
if ($Matches.Major -eq 6 -and $Matches.Minor -eq 3)
{
    # Windows 8.1 / Server 2012 R2 requires a prerequisite hotfix 
    if (-not (Get-HotFix -Id KB2919355 -ErrorAction SilentlyContinue))
    {
        Write-Error "A prerequisite for installing SQL Server Data Tools for Visual Studio 2017 on Windows 8.1 and Windows Server 2012 R2 is to have hotfix KB2919355 installed. See https://msdn.microsoft.com/library/ms143506.aspx for more details"
    }
}

$packageArgs = @{
  packageName   = 'ssdt17'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = $url
  silentArgs    = '/passive /norestart'
  validExitCodes= @(0)
  softwareName  = 'ssdt17*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
