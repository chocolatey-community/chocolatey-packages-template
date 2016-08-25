param($Name, $Type)

<#
.SYNOPSIS
    Create a new package from the template

.DESCRIPTION
    This function creates a new package by using the directory _template which contains desired package basic settings.
#>
function New-Package{
    [CmdletBinding()]
    param(
        #Package name
        [string] $Name,

        #Type of the package
        [ValidateSet('Portable', 'Installer')]
        [string] $Type='Installer',

        #Github repository in the form username/repository
        [string] $GithubRepository
    )

    if ($Name -eq $null) { throw "Name can't be empty" }
    if (Test-Path $Name) { throw "Package with that name already exists" }
    if (!(Test-Path _template)) { throw "Template for the packages not found" }
    cp _template $Name -Recurse

    $nuspec = gc "$Name\template.nuspec"
    rm "$Name\template.nuspec"

    Write-Verbose 'Fixing nuspec'
    $nuspec = $nuspec -replace '<id>.+',               "<id>$Name</id>"
    $nuspec = $nuspec -replace '<iconUrl>.+',          "<iconUrl>https://cdn.rawgit.com/$GithubRepository/master/$Name/icon.png</iconUrl>"
    $nuspec = $nuspec -replace '<packageSourceUrl>.+', "<packageSourceUrl>https://github.com/$GithubRepository/tree/master/$Name</packageSourceUrl>"
    $nuspec | Out-File -Encoding UTF8 "$Name\$Name.nuspec"

    switch ($Type)
    {
        'Installer' {
            Write-Verbose 'Using installer template'
            rm "$Name\tools\chocolateyInstallZip.ps1"
            mv "$Name\tools\chocolateyInstallExe.ps1" "$Name\tools\chocolateyInstall.ps1"
        }
        'Portable' {
            Write-Verbose 'Using portable template'
            rm "$Name\tools\chocolateyInstallExe.ps1"
            mv "$Name\tools\chocolateyInstallZip.ps1" "$Name\tools\chocolateyInstall.ps1"
        }
    }

    Write-Verbose 'Fixing chocolateyInstall.ps1'
    $installer = gc "$Name\tools\chocolateyInstall.ps1"
    $installer -replace "(^[$]packageName\s*=\s*)('.*')", "`$1'$($Name)'" | sc "$Name\tools\chocolateyInstall.ps1"
}

New-Package $Name $Type -GithubRepository majkinetor/chocolatey -Verbose
