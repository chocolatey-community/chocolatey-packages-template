## Automatic Folder

This is where you put your Chocolatey packages that are automatically packaged up by [chocolatey-au](https://github.com/chocolatey-community/chocolatey-au).

Execute `update_all.ps1` in the repository root to run [chocolatey-au](https://github.com/chocolatey-community/chocolatey-au) updater with default options. 

To fully setup all the features ensure you perform the steps in the [setup/README.md](https://github.com/chocolatey/chocolatey-packages-template/blob/master/setup/README.md)

To get the packages that implement chocolatey-au updater run `Get-AUPackages` or `lsau` in this directory.

**NOTE:** Ensure when you are creating packages for chocolatey-au, you don't use `--auto` as the packaging files should be normal packages. chocolatey-au doesn't need the tokens to do replacement.

