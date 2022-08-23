# chocolatey-core.extension

This is a extension package that provides helper functions installed as a Chocolatey extension.
These functions may be used in Chocolatey install/uninstall scripts by declaring this package a dependency in your package's nuspec.
This package provides helper functions that can be used to enhance what is already available out of the box with Chocolatey CLI.
This includes both features that are being tested for Chocolatey CLI itself, and other helpers to make the maintenance of
Chocolatey packages easier.

Helpers that were available in this package, and were later added to Chocolatey CLI, will be moved to
the package [chocolatey-compatibility.extension](https://community.chocolatey.org/packages/chocolatey-compatibility.extension).

Backwards compatibility is not considered for helpers available in this package, see the Notes below.

## Installation

Install via chocolatey: `choco install chocolatey-core.extension`.

The module is usually automatically installed as a dependency.

## Usage

To create a package that uses an extension function add the following to the `nuspec` specification:

    <dependencies>
        <dependency id="chocolatey-core.extension" version="SPECIFY_LATEST_VERSION" />
    </dependencies>

**NOTE**: Make sure you use adequate _minimum_ version.

To test the functions you can import the module directly or via the `chocolateyInstaller.psm1` module:

    PS> import-module $Env:ChocolateyInstall\helpers\chocolateyInstaller.psm1
    PS> import-module $Env:ChocolateyInstall\extensions\chocolatey-core\*.psm1

You can now test any of the functions:

    PS>  Get-AppInstallLocation choco -Verbose

    VERBOSE: Trying local and machine (x32 & x64) Uninstall keys
    VERBOSE: Trying Program Files with 2 levels depth
    VERBOSE: Trying PATH
    C:\ProgramData\chocolatey\bin

Keep in mind that function may work only in the context of the `chocolateyInstaller.ps1`.

To get the list of functions, load the module directly and invoke the following command:

    Get-Command -Module chocolatey-core

To get the help for the specific function use `man`:

    man Get-EffectiveProxy


## Notes

- There is [a known bug](https://github.com/chocolatey-community/chocolatey-extensions/issues/11) in the function `Get-AppInstallLocation` with parameter `$AppNamePattern` which is internally used both as wildcard and regex patterns. This usually doesn't create any problems, but may do so if application contains regex symbols in the name, such as [notepad++](https://github.com/chocolatey-community/chocolatey-coreteampackages/issues/1198).
- This package itself are not concerted of keeping backwards compatibility, if compatibility is of concern take a dependency on [chocolatey-compatibility.extension](https://community.chocolatey.org/packages/chocolatey-compatibility.extension) instead