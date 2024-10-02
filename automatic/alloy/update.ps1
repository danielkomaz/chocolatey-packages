import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_GetLatest {
    $repo = "grafana/alloy"
    $file = "alloy-installer-windows-amd64.exe.zip"
    $releases = "https://api.github.com/repos/$repo/releases"

    Write-Host Determining latest release
    $tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name

    $download = "https://github.com/$repo/releases/download/$tag/$file"

    $Latest = @{ URL64 = $download; Version = $tag }
    return $Latest
}

update
