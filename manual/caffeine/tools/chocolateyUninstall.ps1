$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = 'caffeine'
    zipFileName    = 'caffeine.zip'
}

echo "If Caffeine is currently running on this machine, it will be closed prior to being uninstalled."
ps caffeine -ea 0| kill

Uninstall-ChocolateyZipPackage @packageArgs
