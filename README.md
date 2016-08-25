## Chocolatey Packages Template

This contains Chocolatey packages, both manually and automatically maintained.

### Folder Structure

* automatic - where automatic packaging and packages are kept. These are packages that are automatically maintained using either [AU](https://chocolatey.org/packages/au) or [Ketarin](https://chocolatey.org/packages/ketarin)/[ChocolateyPackageUpdater](https://chocolatey.org/packages/chocolateypackageupdater) combo.
* icons - Where you keep icon files for the packages. This is done to reduce issues when packages themselves move around.
* ketarin - where ketarin jobs (aka applications or searches) exported as XML are kept. This is done to allow ease of contribution.
* manual - where packages that are not automatic are kept.
* ops - scripts, jobs, and other items for ensuring automatic packaging.
* setup - items for prepping the system to ensure for auto packaging.

For setting up your own automatic package repository, please see [Automatic Packaging](https://chocolatey.org/docs/automatic-packages)

### Special Notes

#### Ketarin

* In `Settings -> Global variables` the variable `autoPackagesFolder` is used to determine where your automatic packages are. It doesn't matter what `chocopkgup` is using, this folder is passed through. Ensure this is set appropriately.
* In `Settings -> Global variables` the variable `saveDir` is used to determine where to save the downloaded files from Ketarin. Please ensure the folder exists.
* In `Settings -> Global variables` the variable `nopush` is set to `--nopush`, which allows checksum calculations to occur and then a custom script will push the files.
* In `Settings -> Global variables` the variable `cscript` is set to `2`, which means calculate checksums, rebuild, and push the packages. If you set this to `1` it will do everything except push the packages. Setting this to `1` is how you disable package pushing.
* In `Settings -> Global variables` the variable `checksum` is set to `{checksum}`. Do not change this, this is how the post update script replaces the literal value `{checksum}`. The same goes for `checksumx64`, `packageGuid`, and `url64`.
