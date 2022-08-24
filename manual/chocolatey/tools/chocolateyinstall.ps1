$toolsPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Ensure module loading preference is on
$PSModuleAutoLoadingPreference = "All"

$licensedAssembly = [System.AppDomain]::CurrentDomain.GetAssemblies() |
    Where-Object { $_.GetName().Name -eq 'chocolatey.licensed' } |
    Select-Object -First 1

if ($null -ne $licensedAssembly) {
    # The licensed assembly is installed, check its supported Chocolatey versions and/or the assembly
    # version so we can attempt to determine whether it's compatible with this version of Chocolatey.
    $attributeData = $licensedAssembly.GetCustomAttributes($true)

    $minVersion = $attributeData |
        Where-Object { $_.TypeId -like '*MinimumChocolateyVersion*' } |
        Select-Object -ExpandProperty Version -First 1

    $borderWidth = 70
    try {
        $borderWidth = [System.Console]::BufferWidth - 10
    } catch {
        # Do nothing. This means we're in a non-interactive environment without a console attached.
    }

    $messageBorder = '=' * $borderWidth
    $extensionVersionWarning = @"
$messageBorder

You are installing a version of Chocolatey that may not be compatible with the currently installed version of the chocolatey.extension package.
Running Chocolatey with the current version of the chocolatey.extension package is an unsupported configuration.
See https://ch0.co/compatibility for more information.

If you are also modifying the chocolatey.extension package, you can ignore this warning.

$messageBorder
"@

    if ($null -ne $minVersion) {
        # Found an explicit attribute declaring what version(s) of Chocolatey the current licensed
        # assembly is known to work with.
        # Check what Chocolatey version we're installing in Major.Minor.Patch form, stripping off any prerelease suffix
        $packageVersion = $env:ChocolateyPackageVersion -replace '-.+$' -as [System.Version]

        if ($packageVersion -lt $minVersion) {
            Write-Warning $extensionVersionWarning
        }
    }
    else {
        $version = $attributeData |
            Where-Object { $_.TypeId -like '*AssemblyInformationalVersion*' } |
            Select-Object -ExpandProperty InformationalVersion -First 1

        # Strip off quotes and prerelease suffix if present, that's not critical for this check.
        $version = $version -replace '-.+$' -as [System.Version]

        if ($version.Major -lt 4) {
            Write-Warning $extensionVersionWarning
        }
    }
}

$modules = Get-ChildItem $toolsPath -Filter *.psm1
$modules | ForEach-Object {
	  $psm1File = $_.FullName
	  $moduleName = [System.IO.Path]::GetFileNameWithoutExtension($psm1File)

	  if (Get-Module $moduleName) {
        Remove-Module $moduleName -ErrorAction SilentlyContinue
    }

	  Import-Module -Name $psm1File
}

Initialize-Chocolatey

# SIG # Begin signature block
# MIIZvwYJKoZIhvcNAQcCoIIZsDCCGawCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAEnZUftcVawWaI
# wXxJ48j6cR0WmKRc8VEYQy1GM+GBVqCCFKgwggT+MIID5qADAgECAhANQkrgvjqI
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
# hkiG9w0BCQQxIgQg88S/0fiZ6ALQNNb9pyFFXsb6/g74Nct5bCVmDFhaBoUwDQYJ
# KoZIhvcNAQEBBQAEggEAPhYWeCMgiCDqHkq0BeMQLo8V2hWxVPrlzX08XJ/PUVq7
# MEB9RcJ8o3fqk1Oq/WlbKML2QrCYHNCKN1wYAeJHouKmlM7QZ/3LuN3Dl0xpbnoi
# /cB0zSb3YxBljL2+hDfqVXRBCCQcznNTKv0XWo+HOpcSXUdHhFKOU9Zew201Pnl2
# UptsDb3wIzNpXF79yPioalt8t9IuVhxzJ1Ln3u7XP4MKwYc9fQCGwscltC4bM2iq
# 7lVw1KPkHc/7UtXN/WXgfU/0X03zxX70/dpTxcHV3j9c3i9lE+ss7An1MwkKGyjZ
# P9CKaVTVBdbdSwjM/LsFXAwjPn/68YcXa3ZurJTnFqGCAjAwggIsBgkqhkiG9w0B
# CQYxggIdMIICGQIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNl
# cnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdp
# Q2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBAhANQkrgvjqI/2BA
# Ic4UAPDdMA0GCWCGSAFlAwQCAQUAoGkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
# ATAcBgkqhkiG9w0BCQUxDxcNMjIwMzMwMDc1MTU4WjAvBgkqhkiG9w0BCQQxIgQg
# xmtpuCCyM9GafG5FV3q47JRz2cReZOLkxS3DBfiR1BAwDQYJKoZIhvcNAQEBBQAE
# ggEAZcBQGkqIqaYC+MWdbjyeCH1qA+t8YELTYZZ4l7hrpwZZ0RxBrplD0Gpk72Y2
# qyRrER+gzgl2d9Tqz1PBMJ6y0s0PCp8F01FUM1AtVD8RBhxdRfTGkuGoUHuFgIvF
# 8PE5WRitTLF0ukjtBNkN6MMYD1U/fqjfXr/GnsUl17lomVhvG9gXCsCHgqOhFKqF
# 8uG8vCQVyadttCcvnPgnjtrar3XSX0UgWLdf+6gsuXcDgvAlJmKGpQsweDONxspS
# qdXLUsX7mFzAsDoRoCxPiZoEKyoR2CfzTwImHWTYDeIn4UUsqegLs8uOTClxCbgT
# KRYobW8o0TXGVxL3ONyl8hMrsQ==
# SIG # End signature block
