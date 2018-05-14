$ErrorActionPreference = "Stop"

$packageName = "postgresql10"
$pp = Get-PackageParameters
$password = $pp["Password"]

if(!$password)
{
    $password = Read-Host "Specify a password to be assigned to the postgres user:" -AsSecureString
    $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
}

if(!$password)
{
    # We need to do this to pass package verification.
    $password = [guid]::NewGuid().ToString("N")
    Write-Output "You did not specify a password for the postgres user so an insecure one has been generated for you. Please change it immediately. The password is $($password)"
}

$silentArgs = @(
    "--mode unattended",
    "--unattendedmodeui none",
    "--serverport 5432",
    "--superpassword $($password)",
    "--enable_acledit 1",
    "--install_runtimes 0"
) -join " "

$packageArgs = @{
    packageName = $packageName
    fileType = "exe"
    softwareName = "PostgreSQL"
    url64bit = "https://get.enterprisedb.com/postgresql/postgresql-10.4-1-windows-x64.exe"
    checksum64 = "FA249A648F87C59583AFC0420E729E85CD3CDD9CCB7AD2CD6C121B6318497E73"
    checksumType64 = "sha256"
	url32bit = "https://get.enterprisedb.com/postgresql/postgresql-10.4-1-windows.exe"
    checksum32 = "5CAF289F4990C402CAB775018C40D41F27C1B1B4AAB137D7F68C5177BAB8DC94"
    checksumType32 = "sha256"
    silentArgs = $silentArgs
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
Install-ChocolateyPath "$($env:SystemDrive)\postgresql\pg10\bin" -PathType 'Machine'