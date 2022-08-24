if(-not (test-path "hklm:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\SKUs\.NETFramework,Version=v4.5.1")) {
  Install-ChocolateyPackage 'dotnet451' 'exe' "/Passive /NoRestart /Log $env:temp\net451.log" 'http://download.microsoft.com/download/7/4/0/74078A56-A3A1-492D-BBA9-865684B83C1B/NDP451-KB2859818-Web.exe' -validExitCodes @(0,3010)
  }
  else {
       Write-Host "Microsoft .Net 4.5.1 Framework is already installed on your machine."
   } 