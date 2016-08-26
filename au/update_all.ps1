param($Name = $null)
cd $PSScriptRoot

ls scripts\*.ps1 | % { . $_ }

# used when running locally
if (Test-Path update_vars.ps1) { . ./update_vars.ps1 }

$options = @{
    Timeout = $env:au_timeout
    Push    = $true
    Threads = $env:au_threads 10

    Mail = if ($env:mail_user) {
            @{
                To        = $env:mail_user
                Server    = $env:mail_server
                UserName  = $env:mail_user
                Password  = $env:mail_pass
                Port      = $env:mail_port
                EnableSsl = $true
            }

            if ($env:mail_enablessl -eq 'false') {
                Mail.EnableSsl = $false
            }

           } else {}

    Gist_ID = $Env:Gist_ID

    Script = {
        param($Phase, $Info)

        if ($Phase -ne 'END') { return }

        Save-RunInfo
        Save-Gist
        Save-Git
    }
}

updateall -Name $Name -Options $options | ft
$global:updateall = Import-CliXML $PSScriptRoot\update_info.xml

#Uncomment to fail the build on AppVeyor on any package error
#if ($updateall.error_count.total) { throw 'Errors during update' }
