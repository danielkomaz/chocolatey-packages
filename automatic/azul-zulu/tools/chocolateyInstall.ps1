$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = 'azul-zulu'
  fileType       = 'msi'
  url64bit       = 'https://cdn.azul.com/zulu/bin/zulu23.30.13-ca-fx-jdk23.0.1-win_x64.msi'
  checksum64     = '0e11a80c515f6eefe92fcc227421c2b4e41ced08d4ab51a97c3fef979bb69346'
  checksumType64 = 'sha256'
  silentArgs     = '/qn /norestart  INSTALLDIR="C:\Program Files\Zulu\zulu"'
  validExitCodes = @(0)
  softwareName   = 'Zulu*'
}

Install-ChocolateyPackage @packageArgs
