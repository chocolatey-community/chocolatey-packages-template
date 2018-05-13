$checksum = '118af386fe6af69c1711bff7b1c6dd0d201bd77c1e3fdc46e26d1c5b749e178f'
$url = 'https://go.microsoft.com/fwlink/?linkid=863440'

(Get-WmiObject -Class Win32_OperatingSystem).Version -match "(?<Major>\d+).(?<Minor>\d+).(?<Build>\d+)" | Out-Null
 
if ($Matches.Major -eq 6 -and $Matches.Minor -eq 3)
{
    # Windows 8.1 / Server 2012 R2 requires a prerequisite hotfix 
    if (-not (Get-HotFix -Id KB2919355 -ErrorAction SilentlyContinue))
    {
        Write-Error "A prerequisite for installing SQL Server Data Tools for Visual Studio 2015 on Windows 8.1 and Windows Server 2012 R2 is to have hotfix KB2919355 installed. See https://msdn.microsoft.com/library/ms143506.aspx for more details"
    }
}

$pp = Get-PackageParameters

$packageArgs = @{
  packageName   = 'ssdt15'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'exe'
  url           = $url
  silentArgs    = "/passive /norestart"
  validExitCodes= @(0)
  softwareName  = 'ssdt15*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

if (($pp['analysis'] -eq 'true') -and ($pp['integration'] -eq 'true') -and ($pp['reporting'] -eq 'true'))
{
    $packageArgs.silentArgs += " INSTALLALL=1"
}
else 
{
    if ($pp['analysis'] -eq 'true')
    {
        $packageArgs.silentArgs += " INSTALLAS=1"
    }

    if ($pp['integration'] -eq 'true')
    {
        $packageArgs.silentArgs += " INSTALLIS=1"
    }

    if ($pp['reporting'] -eq 'true')
    {
        $packageArgs.silentArgs += " INSTALLRS=1"
    }

    # else default installation of tools
}

Install-ChocolateyPackage @packageArgs
