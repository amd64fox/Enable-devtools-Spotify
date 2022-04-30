$pathIn = "$env:LOCALAPPDATA\Spotify\offline.bnk"
$ANSI = [Text.Encoding]::GetEncoding(1251)
$old = [IO.File]::ReadAllText($pathIn, $ANSI)
$new = $old -replace "(?<=app-developer..|app-developer>)0", '2'
[IO.File]::WriteAllText($pathIn, $new, $ANSI)