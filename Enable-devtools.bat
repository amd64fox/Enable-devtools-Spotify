@echo off

:: line for changing parameters, each parameter should be separated by a space
:: example:
:: set param=-extra -minimized
set param=

set url='https://raw.githubusercontent.com/amd64fox/Enable-devtools-Spotify/main/Enable-devtools.ps1'
set tls=[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12;

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe ^
-Command %tls% $p='%param%'; """ & { $(iwr -useb %url%)} $p """" | iex

exit /b