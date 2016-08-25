## Setup

### Ketarin/ChocolateyPackageUpdater Automatic Packaging

* Review `setup.ps1` to ensure all items are set appropriately. Uncomment/change anything you need to now.
* Run `setup.ps1`
* Open ketarin after installing it, open the settings and import `KetarinSettings.xml`.

### Automatic Updater (AU)

#### Set up AppVeyor for packaging
* Go to AppVeyor and sign up/sign in. https://ci.appveyor.com/
* Set up an appveyor job - https://ci.appveyor.com/projects/new
* Select your repository to create a new job.
* Go to settings ensure the following items are set (these items cannot be configured in the yaml):
  * In Build Schedule, we want to run this three times a day - set it like this: `5 */6 * * * *`. This ensures it runs at 06:05, 12:05, and 18:05.
  * "Ensure Skip branches without `appveyor.yml`" is checked.
  * "Enable secure variables in Pull Requests from the same repository only" is checked.
  * Click Save.

* Get encrypted values for - https://ci.appveyor.com/tools/encrypt (requires login first)
   * github password (or auth token for 2FA)
   * email password
   * Chocolatey API key
* Edit the appveyor.yml to add those values in.
* Edit the appveyor.yml with the other configuration related items.

#### Setup Local Runs
* Edit `au/update_vars.ps1` and set the same variables there.
* You may also want to install `gist` gem: `cinst ruby; gem install gist` and to make sure `git push` doesn't require credentials.

#### Notes

* If you use Google mail for error notifications on a build server such as AppVeyor, Google may block authentication from unknown device. To receive those emails enable less secure apps - see [Allowing less secure apps to access your account](https://support.google.com/accounts/answer/6010255?hl=en). In any case, do not use your private email for this but create a new Google account and redirect its messages to your private one. This wont affect you if you run the scripts from your own machine from which you usually access the email.
* If you are using AppVeyor you should schedule your build under the _General_ options using [Cron](http://www.nncron.ru/help/EN/working/cron-format.htm) syntax, for example `0 22 * * * *` runs the updater every night at 22h. `5 * * * * *` runs the updater every hour at five past the hour.
* For gist to work the over proxy you need to set console proxy environment variable. See [Update-CLIProxy](https://github.com/majkinetor/posh/blob/master/MM_Network/Update-CLIProxy.ps1) function.
