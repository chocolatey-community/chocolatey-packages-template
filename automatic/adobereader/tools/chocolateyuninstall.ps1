$RegPath = 'HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown'

if (Test-Path $RegPath) {
   $key = Get-ItemProperty -path $RegPath
   if ($key.bUpdater -ne $null) {
      $null = Remove-ItemProperty -Path $RegPath -Name 'bUpdater' -Force
   }
}