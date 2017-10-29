# Close Listary if open
Get-Process "Listary" -ErrorAction SilentlyContinue | stop-process
