function Install-ChocolateyIsoInstallPackage {
<#
.SYNOPSIS
    **NOTE:** Administrative Access Required.

    Installs software into "Programs and Features" based on a remote ISO file download.
    Use Install-ChocolateyIsoPackage when the ISO needs to be downloaded first.

.DESCRIPTION
    This will mount an ISO file, and executes the specified native installer.
    Has error handling built in.
    If you need to download the ISO file first, use Install-ChocolateyIsoPackage instead.

.NOTES
    This command will assert UAC/Admin privileges on the machine.

    If you are embedding ISO files into a package, ensure that you have the
    rights to redistribute those files if you are sharing this package
    publicly (like on the community feed). Otherwise, please use
    Install-ChocolateyIsoPackage to download those resources from their
    official distribution points.

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

.PARAMETER File
    The locatation of the 32bit file inside the ISO.

.PARAMETER File64
    The locatation of the 64bit file inside the ISO.

.PARAMETER ValidExitCodes
    Array of exit codes indicating success. Defaults to `@(0)`.

.PARAMETER UseOnlyPackageSilentArguments
    Do not allow choco to provide/merge additional silent arguments and
    only use the ones available with the package. Available in 0.9.10+.

.PARAMETER IsoFile
    The location of the ISO file.
    If embedding in the package, you can get it to the path with
    `"$(Split-Path -parent $MyInvocation.MyCommand.Definition)\\ISO_FILE"`

.PARAMETER IgnoredArguments
    Allows splatting with arguments that do not apply. Do not use directly.

.EXAMPLE
    >
    $packageName= 'bob'
    $toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
    $fileLocation = Join-Path $toolsDir 'ISO_EMBEDDED_IN_PACKAGE'

    $packageArgs = @{
        packageName   = $packageName
        fileType      = 'msi'
        file          = 'setup.msi'
        file64        = 'x64\setup64.msi'
        silentArgs    = "/qn /norestart"
        validExitCodes= @(0, 3010, 1641)
        softwareName  = 'Bob*'
        isoFile       = $fileLocation
    }

    Install-ChocolateyIsoInstallPackage @packageArgs

.LINK
    Install-ChocolateyPackage

.LINK
    Uninstall-ChocolateyPackage

.LINK
    Get-UninstallRegistryKey

.LINK
    Start-ChocolateyProcessAsAdmin
#>
param(
    [parameter(Mandatory=$true, Position=0)][string] $packageName,
    [parameter(Mandatory=$true, Position=1)][string] $isoFile,
    [parameter(Mandatory=$false, Position=2)]
    [alias("installerType","installType")][string] $fileType = 'exe',
    [parameter(Mandatory=$false, Position=3)][string[]] $silentArgs = '',
    [alias("fileFullPath")][parameter(Mandatory=$false, Position=4)][string] $file = '',
    [alias("fileFullPath64")][parameter(Mandatory=$false)][string] $file64 = '',
    [parameter(Mandatory=$false)] $validExitCodes = @(0),
    [parameter(Mandatory=$false)]
    [alias("useOnlyPackageSilentArgs")][switch] $useOnlyPackageSilentArguments = $false,
    [parameter(ValueFromRemainingArguments = $true)][Object[]] $ignoredArguments
)
    # POSH3 is required for `Mount-DiskImage`
    if ($PSVersionTable.PSVersion -lt (New-Object 'Version' 3,0)) {
        throw 'This function requires PowerShell 3 or higher'
    }

    [string]$silentArgs = $silentArgs -join ' '

    Write-FunctionCallLogMessage -Invocation $MyInvocation -Parameters $PSBoundParameters

    $mountResult = Mount-DiskImage -ImagePath $isoFile -StorageType ISO -PassThru
    $isoVolume = $mountResult | Get-Volume
    $isoDrive = "$($isoVolume.DriveLetter):"

    if (Get-ProcessorBits 64) {
        if ($file64 -ne $null -and $file64 -ne '') {
            $file64 = "$($isoDrive)\$file64"
        }
    }

    $file = "$($isoDrive)\$file"

    try {
      Install-ChocolateyInstallPackage -PackageName $packageName `
                                       -FileType $fileType `
                                       -SilentArgs $silentArgs `
                                       -File $file `
                                       -File64 $file64 `
                                       -ValidExitCodes $validExitCodes `
                                       -UseOnlyPackageSilentArguments:$useOnlyPackageSilentArguments
    } finally {
      Dismount-DiskImage -ImagePath $isoFile -ErrorAction SilentlyContinue
    }
}
