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
    $release = (Invoke-WebRequest $releases | ConvertFrom-Json)[0]
    $tag = $release.tag_name
    if (!$tag) { throw "Could not determine latest release tag from GitHub API response." }

    # remove the v from the tag
    $version = $tag.Substring(1)
    if ($version -notmatch '^\d+\.\d+\.\d+') { throw "Unexpected version format '$version' parsed from tag '$tag'." }

    # Exit if version is release candidate
    if ($version -like "*-rc*") {
        Write-Host "Latest version is a release candidate. Skipping update."
        exit 0
    }

    # Verify the expected asset is actually attached to this release (fail loudly if upstream renames it)
    $asset = $release.assets | Where-Object { $_.name -eq $file }
    if (!$asset) { throw "Release '$tag' does not contain expected asset '$file'. Upstream may have renamed the installer asset - update the `$file variable." }
    $download = $asset.browser_download_url

    # Get the checksum file content
    $checksum_download = "https://github.com/$repo/releases/download/$tag/SHA256SUMS"
    $checksum_content = Invoke-RestMethod -Uri $checksum_download

    # Find the checksum for the file
    $checksum = (($checksum_content -split "`n" | Where-Object { $_ -like "*$file" }) -split " ")[0]
    if (!$checksum -or $checksum -notmatch '^[0-9a-fA-F]{64}$') {
        throw "Could not find a valid SHA256 checksum for '$file' in '$checksum_download'."
    }

    $Latest = @{ URL64 = $download; Version = $version ; Checksum64 = $checksum }
    return $Latest
}

Update-Package -ChecksumFor 64

Set-Location $oldLocation