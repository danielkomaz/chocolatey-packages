$profileInstall = @'
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
'@

$profileFile = "$profile"
$chocoProfileSearch = '$ChocolateyProfile'
if (Select-String -Path $profileFile -Pattern $chocoProfileSearch -Quiet -SimpleMatch) {
  Write-Debug "Chocolatey profile is already installed."
  return
}

$profileInstall | Out-File $profileFile -Append -Encoding (Get-FileEncoding $profileFile)