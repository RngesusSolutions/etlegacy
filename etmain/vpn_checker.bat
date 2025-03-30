@echo off
setlocal enabledelayedexpansion

set REQUESTS_DIR=etmain\vpn_requests
set SLEEP_INTERVAL=5
set MAX_AGE=3600

echo VPN Checker companion script started
echo Monitoring directory: %REQUESTS_DIR%

if not exist %REQUESTS_DIR% mkdir %REQUESTS_DIR%

:loop
for %%F in (%REQUESTS_DIR%\request_*) do (
    set "ip=%%~nF"
    set "ip=!ip:request_=!"
    
    if not exist "%REQUESTS_DIR%\response_!ip!" (
        echo Processing request for IP: !ip!
        
        set /p api_url=<%%F
        
        curl -s "!api_url!" > "%REQUESTS_DIR%\response_!ip!"
        
        echo Response saved for IP: !ip!
    )
)

:: Clean up old files (using PowerShell for date comparison)
powershell -Command "Get-ChildItem '%REQUESTS_DIR%\request_*' | Where-Object {$_.LastWriteTime -lt (Get-Date).AddSeconds(-%MAX_AGE%)} | Remove-Item"
powershell -Command "Get-ChildItem '%REQUESTS_DIR%\response_*' | Where-Object {$_.LastWriteTime -lt (Get-Date).AddSeconds(-%MAX_AGE%)} | Remove-Item"

timeout /t %SLEEP_INTERVAL% /nobreak > nul
goto loop
