# Copyright © 2017 - 2021 Chocolatey Software, Inc.
# Copyright © 2011 - 2017 RealDimensions Software, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Ideas from the Awesome Posh-Git - https://github.com/dahlbyk/posh-git
# Posh-Git License - https://github.com/dahlbyk/posh-git/blob/1941da2472eb668cde2d6a5fc921d5043a024386/LICENSE.txt
# http://www.jeremyskinner.co.uk/2010/03/07/using-git-with-windows-powershell/

$Global:ChocolateyTabSettings = New-Object PSObject -Property @{
    AllCommands = $false
}

$script:choco = "$env:ChocolateyInstall\choco.exe"

function script:chocoCmdOperations($commands, $command, $filter, $currentArguments) {
    $currentOptions = @('zzzz')
    if ($currentArguments -ne $null -and $currentArguments.Trim() -ne '') { $currentOptions = $currentArguments.Trim() -split ' ' }

    $commands.$command.Replace("  "," ") -split ' ' |
      where { $_ -notmatch "^(?:$($currentOptions -join '|' -replace "=", "\="))(?:\S*)\s?$" } |
      where { $_ -like "$filter*" }
}

$script:someCommands = @('-?','search','list','info','install','outdated','upgrade','uninstall','new','download','optimize','pack','push','sync','-h','--help','pin','source','config','feature','apikey','export','help','template','--version')

# ensure these all have a space to start, or they will cause issues
$allcommands = " --debug --verbose --trace --noop --help --accept-license --confirm --limit-output --no-progress --log-file='' --execution-timeout='' --cache-location='' --proxy='' --proxy-user='' --proxy-password='' --proxy-bypass-list='' --proxy-bypass-on-local --force --no-color --skip-compatibility-checks"
$proListOptions = " --audit"
$proInstallUpgradeOptions = " --install-directory='' --package-parameters-sensitive='' --max-download-rate='' --install-arguments-sensitive='' --skip-download-cache --use-download-cache --skip-virus-check --virus-check --virus-positives-minimum='' --deflate-package-size --no-deflate-package-size --deflate-nupkg-only"
$proUpgradeOptions = " --exclude-chocolatey-packages-during-upgrade-all --include-chocolatey-packages-during-upgrade-all"
$proNewOptions = " --file='' --build-package --file64='' --from-programs-and-features --use-original-location --keep-remote --url='' --url64='' --checksum='' --checksum64='' --checksumtype='' --pause-on-error --remove-architecture-from-name --include-architecture-in-name"
$proUninstallOptions = " --from-programs-and-features"
$proPinOptions = " --note=''"

$commandOptions = @{
  list = "--lo --id-only --pre --exact --by-id-only --id-starts-with --detailed --approved-only --not-broken --source='' --user='' --password='' --local-only --prerelease --include-programs --page='' --page-size='' --order-by-popularity --download-cache-only --disable-package-repository-optimizations" + $proListOptions + $allcommands
  search = "--pre --exact --by-id-only --id-starts-with --detailed --approved-only --not-broken --source='' --user='' --password='' --local-only --prerelease --include-programs --page='' --page-size='' --order-by-popularity --download-cache-only --disable-package-repository-optimizations" + $allcommands
  info = "--pre --lo --source='' --user='' --password='' --local-only --prerelease --disable-package-repository-optimizations" + $allcommands
  install = "-y -whatif -? --pre --version= --params='' --install-arguments='' --override-arguments --ignore-dependencies --source='' --source='windowsfeatures' --source='webpi' --user='' --password='' --prerelease --forcex86 --not-silent --package-parameters='' --exit-when-reboot-detected --ignore-detected-reboot --allow-downgrade --force-dependencies --require-checksums --use-package-exit-codes --ignore-package-exit-codes --skip-automation-scripts --allow-multiple-versions --ignore-checksums --allow-empty-checksums --allow-empty-checksums-secure --download-checksum='' --download-checksum-type='' --download-checksum-x64='' --download-checksum-type-x64='' --stop-on-first-package-failure --disable-package-repository-optimizations" + $proInstallUpgradeOptions + $allcommands
  pin = "--name='' --version='' -?" + $proPinOptions + $allcommands
  outdated = "-? --source='' --user='' --password='' --ignore-pinned --ignore-unfound --pre --prerelease --disable-package-repository-optimizations" + $allcommands
  upgrade = "-y -whatif -? --pre --version='' --except='' --params='' --install-arguments='' --override-arguments --ignore-dependencies --source='' --source='windowsfeatures' --source='webpi' --user='' --password='' --prerelease --forcex86 --not-silent --package-parameters='' --exit-when-reboot-detected --ignore-detected-reboot --allow-downgrade --allow-multiple-versions --require-checksums --use-package-exit-codes --ignore-package-exit-codes --skip-automation-scripts --fail-on-unfound --fail-on-not-installed --ignore-checksums --allow-empty-checksums --allow-empty-checksums-secure --download-checksum='' --download-checksum-type='' --download-checksum-x64='' --download-checksum-type-x64='' --exclude-prerelease --stop-on-first-package-failure --use-remembered-options --ignore-remembered-options --skip-when-not-installed --install-if-not-installed --disable-package-repository-optimizations" + $proInstallUpgradeOptions + $proUpgradeOptions + $allcommands
  uninstall = "-y -whatif -? --force-dependencies --remove-dependencies --all-versions --source='windowsfeatures' --source='webpi' --version= --uninstall-arguments='' --override-arguments --not-silent --params='' --package-parameters='' --exit-when-reboot-detected --ignore-detected-reboot --use-package-exit-codes --ignore-package-exit-codes --skip-automation-scripts --use-autouninstaller --skip-autouninstaller --fail-on-autouninstaller --ignore-autouninstaller-failure --stop-on-first-package-failure" + $proUninstallOptions + $allcommands
  new = "--template-name='' --output-directory='' --automaticpackage --version='' --maintainer='' packageversion='' maintainername='' maintainerrepo='' installertype='' url='' url64='' silentargs='' --use-built-in-template -?" + $proNewOptions + $allcommands
  pack = "--version='' --output-directory='' -?" + $allcommands
  push = "--source='' --api-key='' --timeout='' -?" + $allcommands
  source = "--name='' --source='' --user='' --password='' --priority= --bypass-proxy --allow-self-service -?" + $allcommands
  config = "--name='' --value='' -?" + $allcommands
  feature = "--name='' -?" + $allcommands
  apikey = "--source='' --api-key='' --remove -?" + $allcommands
  download = "--internalize --internalize-all-urls --ignore-dependencies --installed-packages --ignore-unfound-packages --resources-location='' --download-location='' --outputdirectory='' --source='' --version='' --prerelease --user='' --password='' --cert='' --certpassword='' --append-use-original-location --recompile --disable-package-repository-optimizations -?" + $allcommands
  sync = "--output-directory='' --id='' --package-id='' -?" + $allcommands
  optimize = "--deflate-nupkg-only --id='' -?" + $allcommands
  export = "--include-version-numbers --output-file-path='' -?" + $allcommands
  template = "--name=''" + $allcommands
}

try {
  # if license exists
  # add in pro/biz switches
}
catch {
}

function script:chocoCommands($filter) {
    $cmdList = @()
    if (-not $global:ChocolateyTabSettings.AllCommands) {
        $cmdList += $someCommands -like "$filter*"
    } else {
        $cmdList += (& $script:choco -h) |
            where { $_ -match '^  \S.*' } |
            foreach { $_.Split(' ', [StringSplitOptions]::RemoveEmptyEntries) } |
            where { $_ -like "$filter*" }
    }

    $cmdList #| sort
}

function script:chocoLocalPackages($filter) {
    if ($filter -ne $null -and $filter.StartsWith(".")) { return; } #file search
    @(& $script:choco list $filter -lo -r --id-starts-with) | %{ $_.Split('|')[0] }
}

function script:chocoLocalPackagesUpgrade($filter) {
    if ($filter -ne $null -and $filter.StartsWith(".")) { return; } #file search
    @('all|') + @(& $script:choco list $filter -lo -r --id-starts-with) | where { $_ -like "$filter*" } | %{ $_.Split('|')[0] }
}

function script:chocoRemotePackages($filter) {
    if ($filter -ne $null -and $filter.StartsWith(".")) { return; } #file search
    @('packages.config|') + @(& $script:choco search $filter --page='0' --page-size='30' -r --id-starts-with --order-by-popularity) | where { $_ -like "$filter*" } | %{ $_.Split('|')[0] }
}

function Get-AliasPattern($exe) {
  $aliases = @($exe) + @(Get-Alias | where { $_.Definition -eq $exe } | select -Exp Name)

  "($($aliases -join '|'))"
}

function ChocolateyTabExpansion($lastBlock) {
  switch -regex ($lastBlock -replace "^$(Get-AliasPattern choco) ","") {

    # Handles uninstall package names
    "^uninstall\s+(?<package>[^\.][^-\s]*)$" {
      chocoLocalPackages $matches['package']
    }

    # Handles install package names
    "^(install)\s+(?<package>[^\.][^-\s]+)$" {
      chocoRemotePackages $matches['package']
    }

    # Handles upgrade / uninstall package names
    "^upgrade\s+(?<package>[^\.][^-\s]*)$" {
      chocoLocalPackagesUpgrade $matches['package']
    }

    # Handles list/search first tab
    "^(list|search)\s+(?<subcommand>[^-\s]*)$" {
      @('<filter>','-?') | where { $_ -like "$($matches['subcommand'])*" }
    }

    # Handles new first tab
    "^(new)\s+(?<subcommand>[^-\s]*)$" {
      @('<name>','-?') | where { $_ -like "$($matches['subcommand'])*" }
    }

    # Handles pack first tab
    "^(pack)\s+(?<subcommand>[^-\s]*)$" {
      @('<PathtoNuspec>','-?') | where { $_ -like "$($matches['subcommand'])*" }
    }

    # Handles push first tab
    "^(push)\s+(?<subcommand>[^-\s]*)$" {
      @('<PathtoNupkg>','-?') | where { $_ -like "$($matches['subcommand'])*" }
    }

    # Handles source first tab
    "^(source)\s+(?<subcommand>[^-\s]*)$" {
      @('list','add','remove','disable','enable','-?') | where { $_ -like "$($matches['subcommand'])*" }
    }

    # Handles pin first tab
    "^(pin)\s+(?<subcommand>[^-\s]*)$" {
      @('list','add','remove','-?') | where { $_ -like "$($matches['subcommand'])*" }
    }

    # Handles feature first tab
    "^(feature)\s+(?<subcommand>[^-\s]*)$" {
      @('list','disable','enable','-?') | where { $_ -like "$($matches['subcommand'])*" }
    }
    # Handles config first tab
    "^(config)\s+(?<subcommand>[^-\s]*)$" {
      @('list','get','set','unset','-?') | where { $_ -like "$($matches['subcommand'])*" }
    }

    # Handles template first tab
    "^(template)\s+(?<subcommand>[^-\s]*)$" {
        @('list', 'info', '-?') | where { $_ -like "$($matches['subcommand'])*" }
    }

    # Handles more options after others
    "^(?<cmd>$($commandOptions.Keys -join '|'))(?<currentArguments>.*)\s+(?<op>\S*)$" {
      chocoCmdOperations $commandOptions $matches['cmd'] $matches['op'] $matches['currentArguments']
    }

    # Handles choco <cmd> <op>
    "^(?<cmd>$($commandOptions.Keys -join '|'))\s+(?<op>\S*)$" {
      chocoCmdOperations $commandOptions $matches['cmd'] $matches['op']
    }

    # Handles choco <cmd>
    "^(?<cmd>\S*)$" {
      chocoCommands $matches['cmd']
    }
  }
}

$PowerTab_RegisterTabExpansion = if (Get-Module -Name powertab) { Get-Command Register-TabExpansion -Module powertab -ErrorAction SilentlyContinue }
if ($PowerTab_RegisterTabExpansion)
{
  & $PowerTab_RegisterTabExpansion "choco" -Type Command {
    param($Context, [ref]$TabExpansionHasOutput, [ref]$QuoteSpaces)  # 1:

    $line = $Context.Line
    $lastBlock = [System.Text.RegularExpressions.Regex]::Split($line, '[|;]')[-1].TrimStart()
    $TabExpansionHasOutput.Value = $true
    ChocolateyTabExpansion $lastBlock
  }

  return
}

if (Test-Path Function:\TabExpansion) {
    Rename-Item Function:\TabExpansion TabExpansionBackup
}

function TabExpansion($line, $lastWord) {
    $lastBlock = [System.Text.RegularExpressions.Regex]::Split($line, '[|;]')[-1].TrimStart()

    switch -regex ($lastBlock) {
        # Execute Chocolatey tab completion for all choco-related commands
        "^$(Get-AliasPattern choco) (.*)" { ChocolateyTabExpansion $lastBlock }

        # Fall back on existing tab expansion
        default { if (Test-Path Function:\TabExpansionBackup) { TabExpansionBackup $line $lastWord } }
    }
}

# SIG # Begin signature block
# MIIZvwYJKoZIhvcNAQcCoIIZsDCCGawCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCChrGS5O3TvWc9N
# G4agkye5RsEIOCe00eP6kYu3uTO2naCCFKgwggT+MIID5qADAgECAhANQkrgvjqI
# /2BAIc4UAPDdMA0GCSqGSIb3DQEBCwUAMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNV
# BAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBUaW1lc3RhbXBpbmcgQ0EwHhcN
# MjEwMTAxMDAwMDAwWhcNMzEwMTA2MDAwMDAwWjBIMQswCQYDVQQGEwJVUzEXMBUG
# A1UEChMORGlnaUNlcnQsIEluYy4xIDAeBgNVBAMTF0RpZ2lDZXJ0IFRpbWVzdGFt
# cCAyMDIxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwuZhhGfFivUN
# CKRFymNrUdc6EUK9CnV1TZS0DFC1JhD+HchvkWsMlucaXEjvROW/m2HNFZFiWrj/
# ZwucY/02aoH6KfjdK3CF3gIY83htvH35x20JPb5qdofpir34hF0edsnkxnZ2OlPR
# 0dNaNo/Go+EvGzq3YdZz7E5tM4p8XUUtS7FQ5kE6N1aG3JMjjfdQJehk5t3Tjy9X
# tYcg6w6OLNUj2vRNeEbjA4MxKUpcDDGKSoyIxfcwWvkUrxVfbENJCf0mI1P2jWPo
# GqtbsR0wwptpgrTb/FZUvB+hh6u+elsKIC9LCcmVp42y+tZji06lchzun3oBc/gZ
# 1v4NSYS9AQIDAQABo4IBuDCCAbQwDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQC
# MAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwQQYDVR0gBDowODA2BglghkgBhv1s
# BwEwKTAnBggrBgEFBQcCARYbaHR0cDovL3d3dy5kaWdpY2VydC5jb20vQ1BTMB8G
# A1UdIwQYMBaAFPS24SAd/imu0uRhpbKiJbLIFzVuMB0GA1UdDgQWBBQ2RIaOpLqw
# Zr68KC0dRDbd42p6vDBxBgNVHR8EajBoMDKgMKAuhixodHRwOi8vY3JsMy5kaWdp
# Y2VydC5jb20vc2hhMi1hc3N1cmVkLXRzLmNybDAyoDCgLoYsaHR0cDovL2NybDQu
# ZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC10cy5jcmwwgYUGCCsGAQUFBwEBBHkw
# dzAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME8GCCsGAQUF
# BzAChkNodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEyQXNz
# dXJlZElEVGltZXN0YW1waW5nQ0EuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBIHNy1
# 6ZojvOca5yAOjmdG/UJyUXQKI0ejq5LSJcRwWb4UoOUngaVNFBUZB3nw0QTDhtk7
# vf5EAmZN7WmkD/a4cM9i6PVRSnh5Nnont/PnUp+Tp+1DnnvntN1BIon7h6JGA078
# 9P63ZHdjXyNSaYOC+hpT7ZDMjaEXcw3082U5cEvznNZ6e9oMvD0y0BvL9WH8dQgA
# dryBDvjA4VzPxBFy5xtkSdgimnUVQvUtMjiB2vRgorq0Uvtc4GEkJU+y38kpqHND
# Udq9Y9YfW5v3LhtPEx33Sg1xfpe39D+E68Hjo0mh+s6nv1bPull2YYlffqe0jmd4
# +TaY4cso2luHpoovMIIFMDCCBBigAwIBAgIQBAkYG1/Vu2Z1U0O1b5VQCDANBgkq
# hkiG9w0BAQsFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5j
# MRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBB
# c3N1cmVkIElEIFJvb3QgQ0EwHhcNMTMxMDIyMTIwMDAwWhcNMjgxMDIyMTIwMDAw
# WjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQL
# ExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3Vy
# ZWQgSUQgQ29kZSBTaWduaW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
# CgKCAQEA+NOzHH8OEa9ndwfTCzFJGc/Q+0WZsTrbRPV/5aid2zLXcep2nQUut4/6
# kkPApfmJ1DcZ17aq8JyGpdglrA55KDp+6dFn08b7KSfH03sjlOSRI5aQd4L5oYQj
# ZhJUM1B0sSgmuyRpwsJS8hRniolF1C2ho+mILCCVrhxKhwjfDPXiTWAYvqrEsq5w
# MWYzcT6scKKrzn/pfMuSoeU7MRzP6vIK5Fe7SrXpdOYr/mzLfnQ5Ng2Q7+S1TqSp
# 6moKq4TzrGdOtcT3jNEgJSPrCGQ+UpbB8g8S9MWOD8Gi6CxR93O8vYWxYoNzQYIH
# 5DiLanMg0A9kczyen6Yzqf0Z3yWT0QIDAQABo4IBzTCCAckwEgYDVR0TAQH/BAgw
# BgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0lBAwwCgYIKwYBBQUHAwMweQYI
# KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
# b20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwgYEGA1UdHwR6MHgwOqA4oDaGNGh0dHA6
# Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmww
# OqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJ
# RFJvb3RDQS5jcmwwTwYDVR0gBEgwRjA4BgpghkgBhv1sAAIEMCowKAYIKwYBBQUH
# AgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCgYIYIZIAYb9bAMwHQYD
# VR0OBBYEFFrEuXsqCqOl6nEDwGD5LfZldQ5YMB8GA1UdIwQYMBaAFEXroq/0ksuC
# MS1Ri6enIZ3zbcgPMA0GCSqGSIb3DQEBCwUAA4IBAQA+7A1aJLPzItEVyCx8JSl2
# qB1dHC06GsTvMGHXfgtg/cM9D8Svi/3vKt8gVTew4fbRknUPUbRupY5a4l4kgU4Q
# pO4/cY5jDhNLrddfRHnzNhQGivecRk5c/5CxGwcOkRX7uq+1UcKNJK4kxscnKqEp
# KBo6cSgCPC6Ro8AlEeKcFEehemhor5unXCBc2XGxDI+7qPjFEmifz0DLQESlE/Dm
# ZAwlCEIysjaKJAL+L3J+HNdJRZboWR3p+nRka7LrZkPas7CM1ekN3fYBIM6ZMWM9
# CBoYs4GbT8aTEAb8B4H6i9r5gkn3Ym6hU/oSlBiFLpKR6mhsRDKyZqHnGKSaZFHv
# MIIFMTCCBBmgAwIBAgIQCqEl1tYyG35B5AXaNpfCFTANBgkqhkiG9w0BAQsFADBl
# MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
# d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJv
# b3QgQ0EwHhcNMTYwMTA3MTIwMDAwWhcNMzEwMTA3MTIwMDAwWjByMQswCQYDVQQG
# EwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNl
# cnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0
# YW1waW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvdAy7kvN
# j3/dqbqCmcU5VChXtiNKxA4HRTNREH3Q+X1NaH7ntqD0jbOI5Je/YyGQmL8TvFfT
# w+F+CNZqFAA49y4eO+7MpvYyWf5fZT/gm+vjRkcGGlV+Cyd+wKL1oODeIj8O/36V
# +/OjuiI+GKwR5PCZA207hXwJ0+5dyJoLVOOoCXFr4M8iEA91z3FyTgqt30A6XLdR
# 4aF5FMZNJCMwXbzsPGBqrC8HzP3w6kfZiFBe/WZuVmEnKYmEUeaC50ZQ/ZQqLKfk
# dT66mA+Ef58xFNat1fJky3seBdCEGXIX8RcG7z3N1k3vBkL9olMqT4UdxB08r8/a
# rBD13ays6Vb/kwIDAQABo4IBzjCCAcowHQYDVR0OBBYEFPS24SAd/imu0uRhpbKi
# JbLIFzVuMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMBIGA1UdEwEB
# /wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMI
# MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNl
# cnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
# RGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MIGBBgNVHR8EejB4MDqgOKA2hjRo
# dHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0Eu
# Y3JsMDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
# cmVkSURSb290Q0EuY3JsMFAGA1UdIARJMEcwOAYKYIZIAYb9bAACBDAqMCgGCCsG
# AQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAsGCWCGSAGG/WwH
# ATANBgkqhkiG9w0BAQsFAAOCAQEAcZUS6VGHVmnN793afKpjerN4zwY3QITvS4S/
# ys8DAv3Fp8MOIEIsr3fzKx8MIVoqtwU0HWqumfgnoma/Capg33akOpMP+LLR2HwZ
# YuhegiUexLoceywh4tZbLBQ1QwRostt1AuByx5jWPGTlH0gQGF+JOGFNYkYkh2OM
# kVIsrymJ5Xgf1gsUpYDXEkdws3XVk4WTfraSZ/tTYYmo9WuWwPRYaQ18yAGxuSh1
# t5ljhSKMYcp5lH5Z/IwP42+1ASa2bKXuh1Eh5Fhgm7oMLSttosR+u8QlK0cCCHxJ
# rhO24XxCQijGGFbPQTS2Zl22dHv1VjMiLyI2skuiSpXY9aaOUjCCBTkwggQhoAMC
# AQICEAq50xD7ISvojIGz0sLozlEwDQYJKoZIhvcNAQELBQAwcjELMAkGA1UEBhMC
# VVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0
# LmNvbTExMC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIENvZGUgU2ln
# bmluZyBDQTAeFw0yMTA0MjcwMDAwMDBaFw0yNDA0MzAyMzU5NTlaMHcxCzAJBgNV
# BAYTAlVTMQ8wDQYDVQQIEwZLYW5zYXMxDzANBgNVBAcTBlRvcGVrYTEiMCAGA1UE
# ChMZQ2hvY29sYXRleSBTb2Z0d2FyZSwgSW5jLjEiMCAGA1UEAxMZQ2hvY29sYXRl
# eSBTb2Z0d2FyZSwgSW5jLjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
# AKFxp42p47c7eHNsNhgxzG+/9A1I8Th+kj40YQJH4Vh0M7a61f39I/FELNYGuyCe
# 0+z/sg+T+4VmT/JMiI2hc75yokTjkv3Yt1+fqABzCMadr+PZ/9ttIVJ5db3P2Uzc
# Ml5wXBdCV5ZH/w4oKcP53VmYcHQEDm/RtAJ9TxlPtLS734oAqrKqBmsnJCI98FWp
# d6z1FK5rv7RJVeZoGsl/2eMcB/ko0Vj9MSCbWvXNjDF9yy4Tl5h2vb+y7K1Qmk3X
# yb0OYB1ibva9rQozGgogEa5DL0OdoMj6cyJ6Cx2GQv2wjKwiKfs9zCOTDH2VGa0i
# okDbsd+BvUxovQ6eSnBFj5UCAwEAAaOCAcQwggHAMB8GA1UdIwQYMBaAFFrEuXsq
# CqOl6nEDwGD5LfZldQ5YMB0GA1UdDgQWBBRO8wUYXZXrKVBqUW35p9FeNJoEgzAO
# BgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwdwYDVR0fBHAwbjA1
# oDOgMYYvaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC1jcy1n
# MS5jcmwwNaAzoDGGL2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3Vy
# ZWQtY3MtZzEuY3JsMEsGA1UdIAREMEIwNgYJYIZIAYb9bAMBMCkwJwYIKwYBBQUH
# AgEWG2h0dHA6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAIBgZngQwBBAEwgYQGCCsG
# AQUFBwEBBHgwdjAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
# ME4GCCsGAQUFBzAChkJodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRTSEEyQXNzdXJlZElEQ29kZVNpZ25pbmdDQS5jcnQwDAYDVR0TAQH/BAIwADAN
# BgkqhkiG9w0BAQsFAAOCAQEAoXGdwcDMMV6xQldozbWoxGTn6chlwO4hJ8aAlwOM
# wexEvDudrlifsiGI1j46wqc9WR8+Ev8w1dIcbqif4inGIHb8GvL22Goq+lB08F7y
# YU3Ry0kOCtJx7JELlID0SI7bYndg17TJUQoAb5iTYD9aEoHMIKlGyQyVGvsp4ubo
# O8CC8Owx+Qq148yXY+to4360U2lzZvUtMpPiiSJTm4BamNgC32xgGwpN5lvk0m3R
# lDdqQQQgBCzrf+ZIMBmXMw4kxY0r/K/g1TkKI9VyiEnRaNQlQisAyYBWVnaHw2EJ
# ck6/bxwdYSA+Sz/Op0N0iEl8MX4At3XQlMGvAI1xhAbrwDGCBG0wggRpAgEBMIGG
# MHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsT
# EHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJl
# ZCBJRCBDb2RlIFNpZ25pbmcgQ0ECEAq50xD7ISvojIGz0sLozlEwDQYJYIZIAWUD
# BAIBBQCggYQwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMx
# DAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkq
# hkiG9w0BCQQxIgQgxmPAgeBqwSYKonTtn69HzwBEbvJ4L01VeKIeWs7B9BcwDQYJ
# KoZIhvcNAQEBBQAEggEAYvQQyo5WaRypHhqSUDX5V/7r0dpvY2oWNxvnC2NwBq1q
# qFliuayGzAxt43F0UmN3rhFPT9pgApjCx62GW4Uh/UYWlNChpygMUJ/zve7k4g+R
# kDJ4jlQ5j0C7qt7ETpOyJVYU2k4zDIpmw2uJpJTmJhdtHTXGdyQF1zNS282Hywdc
# IJGt29US99ejktKbGtPLIXqfC9sakAV11WtR61srz82AyCtbFhXnBpheXRmtgVPd
# 2T5SdNb6E63tCBMhitOapSrIp5qWPOVtPaIKlmcensUIHrcTXAp1ltBM/tCHHSWn
# mUSISkb2FdTtnQkN6ALLH0Y+swnyf2uR4/GzpbeH3qGCAjAwggIsBgkqhkiG9w0B
# CQYxggIdMIICGQIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNl
# cnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdp
# Q2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBAhANQkrgvjqI/2BA
# Ic4UAPDdMA0GCWCGSAFlAwQCAQUAoGkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
# ATAcBgkqhkiG9w0BCQUxDxcNMjIwMzMwMDc1MTU4WjAvBgkqhkiG9w0BCQQxIgQg
# HVJHHIy1VrGkt0caELapyjowqSgsgyAQl0KcHdIZllUwDQYJKoZIhvcNAQEBBQAE
# ggEAbZ0/Y6Th7RdTrWBB4uWCFhKUkzjzjPt7n7B0Tq2G+F9yte3sdNVB/R5uxZws
# xpKCIeJdV19PwIioxF0R0zZAGSDa7Y73t41rUwus4YxW/KaAZr+rvFz/GuedicO6
# BsHTQahWphUWM+mLJr0RA1Yp5HWuOBPOZOXv/9r4gBkCzO1b4dTY2PyRqwTlUG5Z
# GwJqawL44Xcy5oaXMXV9lJVlsV6B0vagtynNJidxiDFm6VRVkj1wPUHPRfxsvwfl
# ySr33Dt/FlgzdaWv4bN5Dz3Avxs+w8DXM63lTJPTJJqv6lVoAYn53LeW1spF7ocV
# a135hsyj4kSiM/fpdaWIj8sVCQ==
# SIG # End signature block
