$ErrorActionPreference = 'Stop';

$packageName = 'grafana-alloy'
$url64 = 'https://github.com/grafana/alloy/releases/download/v1.9.1/alloy-installer-windows-amd64.exe.zip'
$version = '1.9.1'
$fileName = 'alloy-installer-windows-amd64.exe'
$unzipDestination = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$checksum64 = 'ed59a90e0779b8240a8eb5d275d68abd0e928974be39f333eda802c6266070dc'

# Download the package
$zipPackageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  silentArgs     = "/S"
  validExitCodes = @(0, 1223)
  softwareName   = 'Grafana Alloy'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  version        = $version
  unzipLocation  = $unzipDestination
}
Install-ChocolateyZipPackage @zipPackageArgs

# Validate the checksum of the downloaded file
$downloadedFilePath = Join-Path $unzipDestination $fileName

# Get the package parameters
$pp = Get-PackageParameters
Write-Host "Package parameters: $($pp)"

if (!$pp.CONFIG) {
  Write-Host "No configuration file provided. Using default configuration."
  $pp.CONFIG = ""
}
else {
  Write-Host "Using configuration file $($pp.CONFIG)."
}

if (!$pp.DISABLEREPORTING) { 
  $pp.DISABLEREPORTING = "no"
}
else {
  Write-Host "Disabling reporting."
  $pp.DISABLEREPORTING = "yes"
}

if (!$pp.DISABLEPROFILING) {
  $pp.DISABLEPROFILING = "no"
}
else {
  Write-Host "Disabling profiling."
  $pp.DISABLEPROFILING = "yes"
}

if (!$pp.ENVIRONMENT) {
  $pp.ENVIRONMENT = ""
}

$silentArgs = "/S /DISABLEREPORTING=$($pp['DISABLEREPORTING']) /DISABLEPROFILING=$($pp['DISABLEPROFILING']) /CONFIG=$($pp['CONFIG']) /ENVIRONMENT=$($pp['ENVIRONMENT'])"

Write-Host "Silent arguments: $($silentArgs)"

$silentArgs = $silentArgs.Split()

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  file           = $downloadedFilePath
  silentArgs     = $silentArgs
  validExitCodes = @(0, 3010, 1641)
  softwareName   = 'Alloy'
}

Install-ChocolateyInstallPackage @packageArgs
