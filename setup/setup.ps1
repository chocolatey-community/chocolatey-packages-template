# If you change this value, also change it in the global settings
# The name will also be saveDir
$saveDir = "c:\chocolatey-auto-save"

Write-Host "Ensuring that the Ketarin auto save folder is set appropriately."
if (!(Test-Path($saveDir))) {
  mkdir $saveDir
}

@"
## Update Variables - AU
#
# This file is not checked in. It exists only locally.
# These same settings should be verified with appveyor.yml

# Github credentials - used to save result to gist and to commit pushed packages to the git repository
`$env:github_user     = 'YOUR_USER_NAME_HERE'
`$env:github_pass     = 'YOUR_PASSWORD_OR_2FA_AUTH_TOKEN_HERE'
`$env:github_user_repo= 'username/repository'  #https://github.com/chocolatey/chocolatey-packages-template is 'chocolatey/chocolatey-packages-template'

# Email credentials - for error notifications
`$env:mail_user       = 'YOUR_EMAIL_ACCOUNT'
`$env:mail_pass       = 'YOUR_EMAIL_PASSWORD_HERE'
`$env:mail_server     = 'smtp.gmail.com'
`$env:mail_port       = '587'
`$env:mail_enablessl  = 'true'

# Chocolatey API key - to push updated packages
`$env:api_key         = 'YOUR_CHOCO_API_KEY_HERE'

# ID of the gist used to save run results
`$env:gist_id         = 'YOUR_GIST_ID_CREATE_GIST_SAVE_ID_HERE'
"@ | Out-File $PSScriptRoot\..\au\update_vars.ps1 -NoClobber

# Uncomment these next lines if you are using AU
# and have WMF3+ installed.
# Otherwise you need to find a way to install PowerShell PackageManagement

# WMF3/4 only
#choco upgrade dotnet4.5.1 -y
#choco upgrade powershell-packagemanagement --ignore-dependencies -y
#refreshenv # You need the Chocolatey profile installed for this to work properly (Choco v0.9.10.0+).

#choco install ruby -y
#gem install gist

#Install-PackageProvider -Name NuGet -Force
#Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
#Install-Module au -Scope CurrentUser
#Get-Module au -ListAvailable | select Name, Version
