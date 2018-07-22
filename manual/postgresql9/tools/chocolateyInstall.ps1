$ErrorActionPreference = "Stop"

$packageName = "postgresql9"
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
    url64bit = "https://get.enterprisedb.com/postgresql/postgresql-9.6.9-1-windows-x64.exe"
    checksum64 = "E952754B3FDE78C6E8F31F5699AF3AAEA98165CC30523D77C43CD6AB329F7DD3"
    checksumType64 = "sha256"
    url32bit = "https://get.enterprisedb.com/postgresql/postgresql-9.6.9-1-windows.exe"
    checksum32 = "0DECA63FABEFC191C704EA1E3A2CEB8512F1B714BF120CFB98799B9C9EC0D269"
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

Install-ChocolateyPath "$($env:SystemDrive)\$programFiles\postgresql\pg9\bin" -PathType 'Machine'