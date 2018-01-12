If (Get-Service -Name "telegraf" -ErrorAction SilentlyContinue) {
    Stop-Service -Name "telegraf"
}
