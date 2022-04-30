$PSDefaultParameterValues['Stop-Process:ErrorAction'] = [System.Management.Automation.ActionPreference]::SilentlyContinue

Stop-Process -Name Spotify

$offline_bnk = "$env:LOCALAPPDATA\Spotify\offline.bnk"
$spotify_exe = "$env:APPDATA\Spotify\Spotify.exe"
$spotiCheck = (Test-Path -LiteralPath $offline_bnk)
$spotiCheck2 = (Test-Path -LiteralPath $spotify_exe)

if ($spotiCheck -and $spotiCheck2) {
    $offline_bnk = "$env:LOCALAPPDATA\Spotify\offline.bnk"
    $ANSI = [Text.Encoding]::GetEncoding(1251)
    $old = [IO.File]::ReadAllText($offline_bnk, $ANSI)
    $new = $old -replace "(?<=app-developer..|app-developer>)0", '2'
    [IO.File]::WriteAllText($offline_bnk, $new, $ANSI)
    Start-Process -FilePath $spotify_exe
}

else {

    Write-Host 'Spotify not found'
    pause
}
