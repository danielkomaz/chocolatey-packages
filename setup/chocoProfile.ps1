$profileInstall = @'
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
'@

$profileFile = "$profile"
$chocoProfileSearch = '$ChocolateyProfile'
if (Test-Path $profileFile) {
  Write-Debug "Profile file exists."
}
else {
  Write-Debug "Profile file does not exist. Creating it."
  New-Item -Path $profileFile -ItemType File -Force | Out-Null
}
if (Select-String -Path $profileFile -Pattern $chocoProfileSearch -Quiet -SimpleMatch) {
  Write-Debug "Chocolatey profile is already installed."
  return
}

$profileInstall | Out-File $profileFile -Append