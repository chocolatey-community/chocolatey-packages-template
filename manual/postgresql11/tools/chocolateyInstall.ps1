$ErrorActionPreference = "Stop"

$packageName = "postgresql11"
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
    url64bit = "https://get.enterprisedb.com/postgresql/postgresql-11.1-1-windows-x64.exe"
    checksum64 = "3240FF944DB754291BE54D2C33463AFA61E97B2B36BE20846BF452FA46A84B77"
    checksumType64 = "sha256"
    silentArgs = $silentArgs
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

Install-ChocolateyPath "$($env:SystemDrive)\Program Files\postgresql\11\bin" -PathType 'Machine'