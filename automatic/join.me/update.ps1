import-module au

$url = 'https://www.join.me/Download.aspx?installer=win&webdownload=true'

function global:au_SearchReplace {

}

function global:au_GetLatest {
    Write-Host $url

    $temp_file = $env:TEMP + '\join.me.msi'
    Invoke-WebRequest $url -OutFile $temp_file
    Write-Host $temp_file

    $windowsInstaller = New-Object -com WindowsInstaller.Installer

    $database = $windowsInstaller.GetType().InvokeMember(
            "OpenDatabase", "InvokeMethod", $Null, 
            $windowsInstaller, @(([IO.FileInfo]$temp_file).FullName, 0)
        )

    $q = "SELECT Value FROM Property WHERE Property = 'ProductVersion'"
    $View = $database.GetType().InvokeMember(
            "OpenView", "InvokeMethod", $Null, $database, ($q)
        )

    $View.GetType().InvokeMember("Execute", "InvokeMethod", $Null, $View, $Null)

    $record = $View.GetType().InvokeMember(
            "Fetch", "InvokeMethod", $Null, $View, $Null
        )

    $version = $record.GetType().InvokeMember(
            "StringData", "GetProperty", $Null, $record, 1
        )

    $View.GetType().InvokeMember("Close", "InvokeMethod", $Null, $View, $Null)

    $checksum = $(Get-FileHash $temp_file -Algorithm SHA256 | Select-Object -ExpandProperty Hash)
    Write-Host $checksum
    $Latest = @{ Version = $version }
    return $Latest
}

update -NoCheckUrl -ChecksumFor none