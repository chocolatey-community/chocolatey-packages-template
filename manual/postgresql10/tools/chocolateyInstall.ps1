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
    url64bit = "https://get.enterprisedb.com/postgresql/postgresql-10.6-1-windows-x64.exe"
    checksum64 = "6737E003E04BE46A6997A909D5B323A25F25A11340B145B00554A69A080EE53C"
    checksumType64 = "sha256"
    url32bit = "https://get.enterprisedb.com/postgresql/postgresql-10.6-1-windows.exe"
    checksum32 = "9E5F6643A7BEF5E407A6A3023D8FE8C77C8ADBFC458FAE747B02392C9F84966D"
    checksumType32 = "sha256"
    silentArgs = $silentArgs
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

$forceX86 = $env:chocolateyForceX86;
$bitCheck = Get-ProcessorBits

if ($forceX86 -Or $BitCheck -eq 32) {
    $programFiles = 'Program Files (x86)'
} else {
    $programFiles = 'Program Files'
}

Install-ChocolateyPath "$($env:SystemDrive)\$programFiles\postgresql\10\bin" -PathType 'Machine'