param (
    [switch]$allow_pasting,
    [switch]$console,
    [switch]$minimized,
    [switch]$extra
)

function Kill-Spotify {
    param (
        [int]$maxAttempts = 5
    )
    for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
        $spotifyProcesses = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -like "Spotify" }
        if ($spotifyProcesses) {
            foreach ($process in $spotifyProcesses) {
                Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
            }
            Start-Sleep -Milliseconds 500
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

    $pattern = '(?<=app-developer..|app-developer>)'

    switch -Regex ($old) {
        "${pattern}2" {
            $new = $old -replace "${pattern}2", '1'
            $global:foundPattern2 = $true 
        }
        "${pattern}[01]" {
            $new = $old -replace "${pattern}[01]", '2'
        }
    }

    if ($new -ne $null) {
        [IO.File]::WriteAllText($bnk, $new, $ANSI)
    }

}

function Check-Os {
    param(
        [string]$check
    )

    $osVersions = @{
        "win7"  = "6.1"
        "win8"  = "6.2, 6.3"
        "win10" = "10.0"
    }

    $currentVersion = "$(([System.Environment]::OSVersion.Version).Major).$(([System.Environment]::OSVersion.Version).Minor)"

    foreach ($version in $check -split ", ") {
        if ($osVersions.ContainsKey($version) -and $osVersions[$version] -contains $currentVersion) {
            return $true
        }
    }

    return $false
}

function extraApps {

    param(
        [Alias("apps")]
        [string]$folderApps,
        [switch]$extra
    )

    $diagPath = Join-Path -Path $folderApps -ChildPath "diag.spa"
    $visualPath = Join-Path -Path $folderApps -ChildPath "message-visualization.spa"

    if (!$extra -or $global:foundPattern2) {
        return $false
    }

    if ((Test-Path $folderApps -PathType Container)) {
        if ((-not (Test-Path $diagPath -PathType Leaf) -or (Get-Item $diagPath).Length -le 10240) -or
            (-not (Test-Path $visualPath -PathType Leaf) -or (Get-Item $visualPath).Length -le 307200)) {
            return $true
        }
        else {
            return $false
        }
    }
    else {
        New-Item -Path $folderApps -ItemType Directory | Out-Null
        return $true
    }
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
        $apps = Join-Path $spotifyFolder "LocalState\Spotify\Apps"
        $bnkCheck = (Test-Path -LiteralPath $offline_bnk)

        if ($null -ne $spotify_exe -and $bnkCheck) {
            return @{
                exe       = $spotify_exe.Source
                bnk       = $offline_bnk
                apps      = extraApps -apps $apps -extra:$extra
                folderApp = $apps
            }
        }
        else {
            if ($null -eq $spotify_exe) {
                Write-Warning "could not find Spotify.exe for MS, please install/reinstall Spotify"
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
        $apps = "$env:LOCALAPPDATA\Spotify\Apps"
        $bnkCheck = (Test-Path -LiteralPath $offline_bnk)

        if ($spotiCheck -and $bnkCheck) {
            return @{
                exe       = $spotify_exe
                bnk       = $offline_bnk
                apps      = extraApps -apps $apps -extra:$extra
                folderApp = $apps
            }
        }
        else {
            if (!($spotiCheck)) {
                Write-Warning "could not find Spotify.exe, please install/reinstall Spotify"
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

function Dw-Spa {

    param(
        [Alias("apps")]
        [string]$folderApps
    )

    $url = "https://raw.githubusercontent.com/amd64fox/Enable-devtools-Spotify/main/res/{0}.spa"
    $path = "$folderApps\{0}.spa"
    $n = ("diag", "message-visualization")

    function Dw {

        param (
            [Alias("u")]
            [string]$url,

            [Alias("p")]
            [string]$path
        )

        Invoke-RestMethod -Uri $url -OutFile $path
    }

    $n | ForEach-Object { Dw -u ($url -f $_) -p ($path -f $_) }

}

Kill-Spotify

$p = Prepare-Paths

if ($p.apps) { $null = Dw-Spa -apps $p.folderApp }

$foundPattern2 = $false

Update-BNKFile -bnk $p.bnk 

$startProcessArgs = @() 
$params = @{} 

if (-not $foundPattern2) {
    if ($allow_pasting) {
        $startProcessArgs += "--unsafely-disable-devtools-self-xss-warnings"
    }
    if ($console) {
        $startProcessArgs += "--show-console"
    }
    if ($minimized) {
        $startProcessArgs += "--minimized"
    }
}

if ($startProcessArgs) {
    $params["ArgumentList"] = $startProcessArgs 
}

$params["FilePath"] = $p.exe 

Start-Process @params