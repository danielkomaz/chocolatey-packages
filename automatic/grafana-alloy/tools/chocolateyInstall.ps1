$ErrorActionPreference = 'Stop';

$packageName = 'grafana-alloy'
$url64 = 'https://github.com/grafana/alloy/releases/download/v1.5.0/alloy-installer-windows-amd64.exe.zip'
$version = '1.5.0'
$fileName = 'alloy-installer-windows-amd64.exe'
$unzipDestination = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$checksum_download = 'https://github.com/grafana/alloy/releases/download/v1.5.0/SHA256SUMS'
$checksum_content = Invoke-RestMethod -Uri $checksum_download
$checksum = ($checksum_content -split "`n" | Where-Object { $_ -like "*$fileName" }) -split " " | Select-Object -First 1

# Download the package
$zipPackageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  url            = $url64
  url64bit       = $url64
  silentArgs     = "/S"
  validExitCodes = @(0, 1223)
  softwareName   = 'Grafana Alloy'
  checksum       = $checksum
  checksumType   = 'sha256'
  checksum64     = $checksum
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

& "$downloadedFilePath" $silentArgs