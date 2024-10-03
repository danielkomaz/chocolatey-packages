$ErrorActionPreference = 'Stop';

$packageName = 'grafana-alloy'
$url64 = 'https://github.com/grafana/alloy/releases/download/v1.4.1/alloy-installer-windows-amd64.exe.zip'
$checksum64 = 'ff3c73736aa3861bc5f7067d2ad27e4b3114eb10325deb00dcdd43d5e6f96e80'
$version = '1.4.1'
$fileName = 'alloy-installer-windows-amd64.exe'
# $unzipDestination = $env:Temp + '\' + $packageName + '\' + $version + '\'
$unzipDestination = (Split-Path -Parent $MyInvocation.MyCommand.Definition)

$zipPackageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  url            = $url64
  url64bit       = $url64
  silentArgs     = "/S"
  validExitCodes = @(0, 1223)
  softwareName   = 'Grafana Alloy'
  checksum       = $checksum64
  checksumType64 = 'sha256'
  version        = $version
  unzipLocation  = $unzipDestination
}
Install-ChocolateyZipPackage @zipPackageArgs
# Get-ChocolateyUnzip -FileFullPath $url64 -Destination $unzipDestination

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  url            = $unzipDestination + '\' + $fileName
  url64bit       = $unzipDestination + '\' + $fileName
  silentArgs     = "/S"
  validExitCodes = @(0, 1223)
  softwareName   = 'Grafana Alloy'
  checksum       = $checksum64
  checksumType   = 'sha256'
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  version        = $version
}

Install-ChocolateyPackage @packageArgs
