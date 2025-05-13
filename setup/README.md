# Setup Automatic Updater (chocolatey-au)

* Ensure you have the [Chocolatey PowerShell profile](https://docs.chocolatey.org/en-us/troubleshooting#why-does-choco-tab-not-work-for-me) installed.
* Open `au_setup.ps1` in an editor and review it.
* Run PowerShell `5.x` as Administrator (chocolatey-au framework supports PowerShell 6+ but this setup does not).
* Run `au_setup.ps1`.
* For local automatic packaging, copy `update_vars_default.ps1` to `update_default.ps1` and fill it in.
* Configure chocolatey-au [plugins](https://github.com/chocolatey-community/chocolatey-au/blob/master/Plugins.md).
* Configure [AppVeyor](https://github.com/chocolatey-community/chocolatey-au/wiki/AppVeyor).
* Configure [local run](https://github.com/chocolatey-community/chocolatey-au/wiki#local-run).
