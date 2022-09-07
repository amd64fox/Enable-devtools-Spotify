$PSDefaultParameterValues['Stop-Process:ErrorAction'] = [System.Management.Automation.ActionPreference]::SilentlyContinue

Stop-Process -Name Spotify

$offline_bnk = "$env:LOCALAPPDATA\Spotify\offline.bnk"
$spotify_exe = "$env:APPDATA\Spotify\Spotify.exe"
$xpui_spa_patch = "$env:APPDATA\Spotify\Apps\xpui.spa"
$xpui_spa_copy = "$env:APPDATA\Spotify\Apps\xpui.spa.adminbak"
$xpui_js_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.js"
$xpui_js_copy = "$env:APPDATA\Spotify\Apps\xpui\xpui.js.adminbak"
$xpui_spaCheck = (Test-Path -LiteralPath $xpui_spa_patch)
$bnkCheck = (Test-Path -LiteralPath $offline_bnk)
$spotiCheck = (Test-Path -LiteralPath $spotify_exe)
$xpui_jsCheck = (Test-Path -LiteralPath $xpui_js_patch)
$debugTools = '(return ).{1,3}(\?.{1,4}createElement\(.{3,7}{displayText:"Debug Tools")' , '$1true$2'
$employee = '(..\(.\))(\?..createElement\(.{1,3},{filterMatchQuery:.{2,15}\("settings.employee"\))', 'true$2'

if (!($spotiCheck)) {

    Write-Host "Spotify not found"`n
    exit
}
if ($bnkCheck) {
    $ANSI = [Text.Encoding]::GetEncoding(1251)
    $old = [IO.File]::ReadAllText($offline_bnk, $ANSI)
    $new = $old -replace '(?<=app-developer..|app-developer>)0', '2'
    [IO.File]::WriteAllText($offline_bnk, $new, $ANSI)
}

else {
    Write-Host "offline.bnk not found"`n
    Write-Host "Seems like Spotfiy hasn't been launched yet, you need to login to your account `nwait for Spotfiy to fully launch, then close it and run the script again"`n
    pause
    exit
}

if ($xpui_jsCheck -and $xpui_spaCheck) { 
    Write-Host "Location of Spotify files is broken, reinstall Spotify"
    Write-Host "Part of the DevTools functionality is not activated"`n
    Start-Process -FilePath $spotify_exe
    pause
    exit
}
if (!($xpui_jsCheck) -and !($xpui_spaCheck)) { 
    Write-Host "xpui system files not found, reinstall Spotify"`n
    pause
    exit
}

if ($xpui_spaCheck) {

    copy-Item $xpui_spa_patch $xpui_spa_copy

    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
    $entry_xpui = $zip.GetEntry('xpui.js')
    $reader = New-Object System.IO.StreamReader($entry_xpui.Open())
    $xpui_js = $reader.ReadToEnd()
    $reader.Close()

    $xpui_js = $xpui_js -replace $debugTools[0], $debugTools[1] -replace $employee[0] , $employee[1]

    $writer = New-Object System.IO.StreamWriter($entry_xpui.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_js)
    $writer.Close()
    $zip.Dispose()

    Start-Process -FilePath $spotify_exe

    Start-Sleep -Milliseconds 1500

    Remove-item $xpui_spa_patch -Recurse -Force
    Rename-Item -path $xpui_spa_copy -NewName $xpui_spa_patch
}

if ($xpui_jsCheck) {

    copy-Item $xpui_js_patch $xpui_js_copy

    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $xpui_js_patch
    $xpui_js = $reader.ReadToEnd()
    $reader.Close()

    $xpui_js = $xpui_js -replace $debugTools[0], $debugTools[1] -replace $employee[0] , $employee[1]
    $writer = New-Object System.IO.StreamWriter -ArgumentList $xpui_js_patch
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_js)
    $writer.Close()

    Start-Process -FilePath $spotify_exe

    Start-Sleep -Milliseconds 1500

    Remove-item $xpui_js_patch -Recurse -Force
    Rename-Item -path $xpui_js_copy -NewName $xpui_js_patch
}