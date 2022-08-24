if(-not (test-path "hklm:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\SKUs\.NETFramework,Version=v4.5.2")) {
Install-ChocolateyPackage 'dotnet452' 'exe' "/Passive /NoRestart /Log $env:temp\net451.log" 'http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe' -validExitCodes @(0,3010)
}
else {
     Write-Host "Microsoft .Net 4.5.2 Framework is already installed on your machine."
 } 
