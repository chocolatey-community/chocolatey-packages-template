# Chocolatey Packages

[![Build Status](https://dev.azure.com/EnsembleHealth/EHIF-ITOps/_apis/build/status/chocolatey-packages?branchName=master)](https://dev.azure.com/EnsembleHealth/EHIF-ITOps/_build/latest?definitionId=684&branchName=master)
[![Update status](https://img.shields.io/badge/Update-Status-blue.svg)](https://gist.github.com/automateazure/a10db4d96e25cd048cd1ed1ec2a086f4

If you have any issues with one of the packages hosted in this repository, please feel free to open an issue (preferred instead of using `Contact Maintainers` on chocolatey.org).

This repository contains [chocolatey automatic packages](https://docs.chocolatey.org/en-us/create/automatic-packages).
The repository is setup so that you can manage your packages entirely from the GitHub web interface (using AppVeyor to update and push packages) and/or using the local repository copy.

## Chocolatey Packages Template

This contains Chocolatey packages, both manually and automatically maintained.

### Folder Structure

* automatic - where automatic packaging and packages are kept. These are packages that are automatically maintained using [AU](https://community.chocolatey.org/packages/au).
* deprecated - where packages that are deprecated are kept.
* icons - Where you keep icon files for the packages. This is done to reduce issues when packages themselves move around.
* manual - where packages that are not automatic are kept.
* retired - where packages that are retired are kept.

For setting up your own automatic package repository, please see [Automatic Packaging](https://docs.chocolatey.org/en-us/create/automatic-packages)

### Requirements

* Chocolatey (choco.exe)

#### AU

* PowerShell v5+.
* The [AU module](https://community.chocolatey.org/packages/au).

For daily operations check out the AU packages [template README](https://github.com/majkinetor/au-packages-template/blob/master/README.md).

### Getting started

1. Fork this repository and rename it to `chocolatey-packages` (on GitHub - go into Settings, Repository name and rename).
1. Clone the repository locally.
1. Head into the `setup` folder and perform the proper steps for your choice of setup (or both if you plan to use both methods).
1. Edit this README. Update the badges at the top.


### Recommendation on Auto Packaging

AU provides more in the process of being completely automated, sending emails when things go wrong, and providing a nice report at the end.

So for best visibility, enjoying the ease of using AppVeyor, and for a nice report of results. AU works directly with the xml/ps1 files to do replacement.

### Adapting your current source repository to this source repository template

You want to bring in all of your packages into the proper folders. We suggest using some sort of diffing tool to look at the differences between your current solution and this solution and then making adjustments to it. Pay special attention to the setup folder.

1. Bring over the following files to your package source repository:

* `automatic\README.md`
* `deprecated\README.md`
* `icons\README.md`
* `manual\README.md`
* `retired\README.md`
* `.appveyor.yml`

1. Inspect the following file and add the differences:

* `.gitignore`