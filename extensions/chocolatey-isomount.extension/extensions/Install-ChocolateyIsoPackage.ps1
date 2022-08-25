function Install-ChocolateyIsoPackage {
<#
.SYNOPSIS
    **NOTE:** Administrative Access Required.

    Installs software into "Programs and Features" based on a remote ISO file download.
    Use Install-ChocolateyIsoInstallPackage when using a local or embedded file.

.DESCRIPTION
    This will download an ISO file from an URL, mounts it and executes the specified native installer.
    Has error handling built in.
    If you are embedding the file(s) directly in the package (or do not need to download a file first),
    use Install-ChocolateyIsoInstallPackage instead.

.NOTES
    This command will assert UAC/Admin privileges on the machine.

    It will download the ISO file to the 'IsoCache' folder, if it is not already there.
    This will prevent downloading the same ISO file over and over again. This function can be disabled
    on a per package base by setting the 'NoCache' parameter to $true

    This is a wrapper around several existing Chocolatey commandlets.

    Chocolatey is copyrighted by its rightful owners. See: https://chocolatey.org

.INPUTS
    None

.OUTPUTS
    None

.PARAMETER PackageName
    The name of the package - while this is an arbitrary value, it's
    recommended that it matches the package id.

.PARAMETER FileType
    This is the extension of the file. This can be 'exe', 'msi', or 'msu'.
    Licensed editions of Chocolatey use this to automatically determine
    silent arguments. If this is not provided, Chocolatey will
    automatically determine this using the downloaded file's extension.

.PARAMETER SilentArgs
    OPTIONAL - These are the parameters to pass to the native installer,
    including any arguments to make the installer silent/unattended.
    Licensed editions of Chocolatey will automatically determine the
    installer type and merge the arguments with what is provided here.

    Try any of the to get the silent (unattended) installer -
    `/s /S /q /Q /quiet /silent /SILENT /VERYSILENT`. With msi it is always
    `/quiet`. Please pass it in still but it will be overridden by
    Chocolatey to `/quiet`. If you don't pass anything it could invoke the
    installer with out any arguments. That means a nonsilent installer.

    Please include the `notSilent` tag in your Chocolatey package if you
    are not setting up a silent/unattended package. Please note that if you
    are submitting to the community repository, it is nearly a requirement
    for the package to be completely unattended.

    When you are using this with an MSI, it will set up the arguments as
    follows:
    `"C:\Full\Path\To\msiexec.exe" /i "$downloadedFileFullPath" $silentArgs`,
    where `$downloadedfileFullPath` is `$url` or `$url64`, depending on what
    has been decided to be used.

    When you use this with MSU, it is similar to MSI above in that it finds
    the right executable to run.

    When you use this with executable installers, the
    `$downloadedFileFullPath` will also be `$url`/`$url64` SilentArgs is
    everything you call against that file, as in
    `"$fileFullPath" $silentArgs"`. An example would be
    `"c:\path\setup.exe" /S`, where
    `$downloadedfileFullPath = "c:\path\setup.exe"` and `$silentArgs = "/S"`.

.PARAMETER Url
    This is the url to download the resource from.

    Prefer HTTPS when available. Can be HTTP, FTP, or File URIs.

.PARAMETER ValidExitCodes
    Array of exit codes indicating success. Defaults to `@(0)`.

.PARAMETER Checksum
    The checksum hash value of the Url resource. This allows a checksum to
    be validated for files that are not local. The checksum type is covered
    by ChecksumType.

    **NOTE:** Checksums in packages are meant as a measure to validate the
    originally intended file that was used in the creation of a package is
    the same file that is received at a future date. Since this is used for
    other steps in the process related to the community repository, it
    ensures that the file a user receives is the same file a maintainer
    and a moderator (if applicable), plus any moderation review has
    intended for you to receive with this package. If you are looking at a
    remote source that uses the same url for updates, you will need to
    ensure the package also stays updated in line with those remote
    resource updates. You should look into [automatic packaging](https://chocolatey.org/docs/automatic-packages)
    to help provide that functionality.

    **NOTE:** To determine checksums, you can get that from the original
    site if provided. You can also use the [checksum tool available on
    the community feed](https://community.chocolatey.org/packages/checksum) (`choco install checksum`)
    and use it e.g. `checksum -t sha256 -f path\to\file`. Ensure you
    provide checksums for all remote resources used.

.PARAMETER ChecksumType
    The type of checkum that the file is validated with - valid
    values are 'md5', 'sha1', 'sha256' or 'sha512' - defaults to 'md5'.

    MD5 is not recommended as certain organizations need to use FIPS
    compliant algorithms for hashing - see
    https://support.microsoft.com/en-us/kb/811833 for more details.

    The recommendation is to use at least SHA256.

.PARAMETER Options
    OPTIONAL - Specify custom headers. Available in 0.9.10+.

.PARAMETER File
    The locatation of the 32bit file inside the ISO.

.PARAMETER File64
    The locatation of the 64bit file inside the ISO.

.PARAMETER UseOnlyPackageSilentArguments
    Do not allow choco to provide/merge additional silent arguments and only
    use the ones available with the package. Available in 0.9.10+.

.PARAMETER IsoCache
    OPTIONAL - Full path to a cache location. Defaults to `$env:Temp`.

.PARAMETER IgnoredArguments
    Allows splatting with arguments that do not apply. Do not use directly.

.EXAMPLE
    >
    $packageName= 'bob'
    $toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
    $url        = 'https://somewhere.com/file.iso'

    $packageArgs = @{
        packageName   = $packageName
        fileType      = 'msi'
        url           = $url
        file          = 'setup.msi'
        file64        = 'x64\setup64.msi'
        silentArgs    = "/qn /norestart"
        validExitCodes= @(0, 3010, 1641)
        softwareName  = 'Bob*'
        checksum      = '12345'
        checksumType  = 'sha256'
    }

    Install-ChocolateyIsoPackage @packageArgs

.LINK
    Install-ChocolateyIsoInstallPackage

.LINK
    Get-ChocolateyWebFile

.LINK
    Install-ChocolateyInstallPackage

.LINK
    Get-UninstallRegistryKey

.LINK
    Install-ChocolateyZipPackage
#>

param(
    [parameter(Mandatory=$true, Position=0)][string] $packageName,
    [parameter(Mandatory=$true, Position=1)][string] $url,
    [parameter(Mandatory=$false, Position=2)]
    [alias("installerType","installType")][string] $fileType = 'exe',
    [parameter(Mandatory=$false, Position=3)][string[]] $silentArgs = '',
    [parameter(Mandatory=$false)] $validExitCodes = @(0),
    [parameter(Mandatory=$false)][string] $checksum = '',
    [parameter(Mandatory=$false)][string] $checksumType = '',
    [parameter(Mandatory=$false)][hashtable] $options = @{Headers=@{}},
    [alias("fileFullPath")][parameter(Mandatory=$false)][string] $file = '',
    [alias("fileFullPath64")][parameter(Mandatory=$false)][string] $file64 = '',
    [parameter(Mandatory=$false)]
    [alias("useOnlyPackageSilentArgs")][switch] $useOnlyPackageSilentArguments = $false,
    [parameter(Mandatory=$false)][string] $isoCache = $env:TEMP,
    [parameter(ValueFromRemainingArguments = $true)][Object[]] $ignoredArguments
)
    # POSH3 is required for `Mount-DiskImage`
    if ($PSVersionTable.PSVersion -lt (New-Object 'Version' 3,0)) {
        throw 'This function requires PowerShell 3 or higher'
    }

    [string]$silentArgs = $silentArgs -join ' '

    Write-FunctionCallLogMessage -Invocation $MyInvocation -Parameters $PSBoundParameters

    if (![System.IO.Directory]::Exists($isoCache)) { [System.IO.Directory]::CreateDirectory($isoCache) | Out-Null }
    $downloadFileName = "$($packageName)Image.iso"
    if ($url.EndsWith(".iso")) {
        $downloadFileName = $url.Substring($url.LastIndexOf("/") + 1)
    }

    $downloadFilePath = Join-Path $isoCache $downloadFileName

    $isoPath = Get-ChocolateyWebFile -PackageName $packageName `
                                     -FileFullPath $downloadFilePath `
                                     -Url $url `
                                     -Checksum $checksum `
                                     -ChecksumType $checksumType `
                                     -Options $options `
                                     -GetOriginalFileName

    Install-ChocolateyIsoInstallPackage -PackageName $packageName `
                                        -IsoFile $isoPath `
                                        -FileType $fileType `
                                        -SilentArgs $silentArgs `
                                        -File $file `
                                        -File64 $file64 `
                                        -ValidExitCodes $validExitCodes `
                                        -UseOnlyPackageSilentArguments:$useOnlyPackageSilentArguments
}
