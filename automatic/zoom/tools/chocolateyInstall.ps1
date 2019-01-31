﻿$checksum = '888ced6cf6b3a6231c5de20ff52694377078a9c662a9f5e5cde11afd8ed6f434'
$url = 'https://zoom.us/client/latest/ZoomInstallerFull.msi'

$packageArgs = @{
  packageName   = 'zoom'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType      = 'msi'
  url           = $url
  silentArgs    = '/quiet /norestart'
  validExitCodes= @(0)
  softwareName  = 'zoom*'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
