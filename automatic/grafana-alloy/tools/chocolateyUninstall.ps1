$uninstall = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -match "Alloy" } | Select-Object -Property DisplayName, UninstallString

$uninstall.UninstallString = $uninstall.UninstallString -replace '"', ''

& $uninstall.UninstallString /S