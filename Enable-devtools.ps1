function Kill-Spotify {
    param (
        [int]$maxAttempts = 5
    )

    for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
        $allProcesses = Get-Process -ErrorAction SilentlyContinue

        $spotifyProcesses = $allProcesses | Where-Object { $_.ProcessName -like "*spotify*" }

        if ($spotifyProcesses) {
            foreach ($process in $spotifyProcesses) {
                try {
                    Stop-Process -Id $process.Id -Force
                }
                catch {
                    # Ignore NoSuchProcess exception
                }
            }
            Start-Sleep -Seconds 1
        }
        else {
            break
        }
    }

    if ($attempt -gt $maxAttempts) {
        Write-Host "The maximum number of attempts to terminate a process has been reached."
    }
}

function Update-BNKFile {
    param (
        [string]$bnk
    )

    $ANSI = [Text.Encoding]::GetEncoding(1251)
    $old = [IO.File]::ReadAllText($bnk, $ANSI)
    $new = $old -replace '(?<=app-developer..|app-developer>)[01]', '2'
    [IO.File]::WriteAllText($bnk, $new, $ANSI)
}

function Check-Os {
    param(
        [string]$check
    )

    $osVersions = @{}
    $osVersions["win7"] = "6.1"
    $osVersions["win8"] = "6.2, 6.3"
    $osVersions["win10"] = "10.0"

    $currentVersion = "$(([System.Environment]::OSVersion.Version).Major).$(([System.Environment]::OSVersion.Version).Minor)"

    foreach ($version in $check -split ", ") {
        if ($osVersions.ContainsKey($version) -and $osVersions[$version] -contains $currentVersion) {
            return $true
        }
    }

    return $false
}

function Prepare-Paths {

    $psv = $PSVersionTable.PSVersion.major

    if ($psv -ge 7) {
        Import-Module Appx -UseWindowsPowerShell -WarningAction:SilentlyContinue
    }

    if ((Check-Os "win8, win10") -and (Get-AppxPackage -Name SpotifyAB.SpotifyMusic)) {

        $spotify_exe = Get-Command -Name Spotify
        $spotifyFolder = Get-ChildItem "$env:LOCALAPPDATA\Packages\" -Filter "SpotifyAB.SpotifyMusic*" -Directory | Select-Object -ExpandProperty FullName
        $offline_bnk = Join-Path $spotifyFolder "LocalState\Spotify\offline.bnk"
        $bnkCheck = (Test-Path -LiteralPath $offline_bnk)

        if ($null -ne $spotify_exe -and $bnkCheck) {
            return @{
                exe = $spotify_exe.Source
                bnk = $offline_bnk
            }
        }
        else {
            if ($null -eq $spotify_exe) {
                Write-Warning "could not find Spotify.exe for MS"
                pause
                exit
            }
            else {
                Write-Warning "could not find offline.bnk for MS, please login to Spotify"
                pause
                exit
            }

        }
    }
    else {

        $spotify_exe = "$env:APPDATA\Spotify\Spotify.exe"
        $spotiCheck = (Test-Path -LiteralPath $spotify_exe)
        $offline_bnk = "$env:LOCALAPPDATA\Spotify\offline.bnk"
        $bnkCheck = (Test-Path -LiteralPath $offline_bnk)

        if ($spotiCheck -and $bnkCheck) {
            return @{
                exe = $spotify_exe
                bnk = $offline_bnk
            }
        }
        else {
            if (!($spotiCheck)) {
                Write-Warning "could not find Spotify.exe"
                pause
                exit
            }
            else {
                Write-Warning "could not find offline.bnk, please login to Spotify"
                pause
                exit
            }
        }
    }
}

Kill-Spotify

$p = Prepare-Paths

Update-BNKFile -bnk $p.bnk

Start-Process -FilePath $p.exe