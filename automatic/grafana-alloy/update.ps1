Import-Module AU

$oldLocation = Get-Location

Set-Location $PSScriptRoot

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]version\s*=\s*)('.*')"    = "`$1'$($Latest.Version)'"
        }
    }
}

function global:au_GetLatest {
    $repo = "grafana/alloy"
    $file = "alloy-installer-windows-amd64.exe.zip"
    $releases = "https://api.github.com/repos/$repo/releases"

    Write-Host Determining latest release
    $tag = (Invoke-WebRequest $releases | ConvertFrom-Json )[0].tag_name

    # remove the v from the tag
    $version = $tag.Substring(1)

    $download = "https://github.com/$repo/releases/download/$tag/$file"

    # Get the checksum file content
    $checksum_download = "https://github.com/$repo/releases/download/$tag/SHA256SUMS"
    $checksum_content = Invoke-RestMethod -Uri $checksum_download

    # Find the checksum for the file
    $checksum = ($checksum_content -split "`n" | Where-Object { $_ -like "*$file" }) -split " " | Select-Object -First 1

    $Latest = @{ URL64 = $download; Version = $version ; Checksum64 = $checksum }
    return $Latest
}

Update-Package -ChecksumFor 64

Set-Location $oldLocation