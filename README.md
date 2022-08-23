https://gist.github.com/automateazure/a10db4d96e25cd048cd1ed1ec2a086f4

This repository contains [chocolatey automatic packages](https://chocolatey.org/docs/automatic-packages).  

## Prerequisites

To run locally you will need:

- Powershell 5+.
- [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au): `Install-Module au` or `cinst au`.


## Create a package

To create a new package see [Creating the package updater script](https://github.com/majkinetor/au#creating-the-package-updater-script).

## Testing the package

In a package directory run: `Test-Package`. This function can be used to start testing in [chocolatey-test-environment](https://github.com/majkinetor/chocolatey-test-environment) via `Vagrant` parameter or it can test packages locally.


## Automatic package update

### Single package

Run from within the directory of the package to update that package:
   
    cd <package_dir>
    ./update.ps1
 
If this script is missing, the package is not automatic.  
Set `$au_Force = $true` prior to script call to update the package even if no new version is found.

### Multiple packages
 
To update all packages run `./update_all.ps1`. It accepts few options:

```powershell
./update_all.ps1 -Name a*                         # Update all packages which name start with letter 'a'
./update_all.ps1 -ForcedPackages 'cpu-z copyq'    # Update all packages and force cpu-z and copyq
./update_all.ps1 -ForcedPackages 'copyq:1.2.3'    # Update all packages but force copyq with explicit version
./update_all.ps1 -ForcedPackages 'libreoffice-streams\fresh:6.1.0]'    # Update all packages but force libreoffice-streams package to update stream `fresh` with explicit version `6.1.0`.
./update_all.ps1 -Root 'c:\packages'              # Update all packages in the c:\packages folder
```

The following global variables influence the execution of `update_all.ps1` script if set prior to the call:

```powershell
$au_NoPlugins = $true        #Do not execute plugins
$au_Push      = $false       #Do not push to chocolatey
```

You can also call AU method `Update-AUPackages` (alias `updateall`) on its own in the repository root. This will just run the updater for the each package without any other option from `update_all.ps1` script. For example to force update of all packages with a single command execute:

    updateall -Options ([ordered]@{ Force = $true })

## Testing all packages

You can force the update of all or subset of packages to see how they behave when complete update procedure is done:


```powershell
./test_all.ps1                            # Test force update on all packages
./test_all.ps1 'cdrtfe','freecad', 'p*'   # Test force update on only given packages
./test_all.ps1 'random 3'                 # Split packages in 3 groups and randomly select and test 1 of those each time
```


**Note**: If you run this locally your packages will get updated. Use `git reset --hard` after running this to revert the changes.
