$ErrorActionPreference = 'Stop';

$packageName = 'grafana-alloy'
$url64 = 'https://github.com/grafana/alloy/releases/download/v1.5.0/alloy-installer-windows-amd64.exe.zip'
$checksum64 = '59b2d8bd745d1fef88f04ed79133ee87789be6d796735aed5fe5e062e94458f7'
$version = '1.5.0'
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
