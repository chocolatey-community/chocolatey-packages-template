# Chocolatey ISO helpers extension

This is a Chocolatey extension that simplifies building Chocolatey packages that require deployments via ISO files.

**NOTE**: This package requires PowerShell 3 or higher

## Installation

Install via chocolatey: `choco install chocolatey-isomount.extension`.

The module is usually automatically installed as a dependency.

## Usage

To create a package that uses a function from this extension add the following to the `nuspec` specification:

```xml
<dependencies>
    <dependency id="chocolatey-isomount.extension" version="SPECIFY_LATEST_VERSION" />
</dependencies>
```

**NOTE**: Make sure you use adequate _minimum_ version.

To test the functions you can import the module directly or via the `chocolateyInstaller.psm1` module:

```powershell
PS> import-module $Env:ChocolateyInstall\helpers\chocolateyInstaller.psm1
PS> import-module $Env:ChocolateyInstall\extensions\chocolatey-isomount\*.psm1
```

You can now test any of the functions:

```powershell
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
```

Keep in mind that function may work only in the context of the `chocolateyInstaller.ps1`.

To get the list of functions, load the module directly and invoke the following command:

```powershell
Get-Command -Module chocolatey-isomount
```

To get the help for the specific function use `man`:

```powershell
man Install-ChocolateyIsoPackage
```
