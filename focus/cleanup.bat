@echo off
setlocal

:: Get current date and time components
for /F "tokens=2-4 delims=/ " %%a in ('echo %date%') do (
    set month=%%a
    set day=%%b
    set year=%%c
)
for /F "tokens=1-2 delims=:. " %%a in ('echo %time%') do (
    set hour=%%a
    set minute=%%b
)

:: Pad single-digit months and days with a leading zero
if %month% LSS 10 set month=0%month%
if %day% LSS 10 set day=0%day%

:: Define log file name with date and time
set mydate=%year%-%month%-%day%
set mytime=%hour%-%minute%
set "logFile=D:\cleanuplogs\cleanup-log-%mydate%-%mytime%.log"
echo Log file: %logFile%

:: Direct logging to see if date and time are set correctly
echo [%mydate% %mytime%] Script started >> %logFile%
echo Script started

:: Check for admin privileges
echo Checking for admin privileges...
echo [%mydate% %mytime%] Checking for admin privileges... >> %logFile%
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo [%mydate% %mytime%] Requesting administrative privileges... >> %logFile%
    echo Requesting administrative privileges...
    echo Please run this script with administrative privileges.
    pause
    exit /b
)
echo [%mydate% %mytime%] Admin privileges confirmed. >> %logFile%
echo Admin privileges confirmed.

:: Stop IIS service
echo Stopping IIS service...
echo [%mydate% %mytime%] Stopping IIS service... >> %logFile%
net stop w3svc >> %logFile% 2>&1
if '%errorlevel%' NEQ '0' (
    echo [%mydate% %mytime%] Failed to stop IIS service. >> %logFile%
    echo Failed to stop IIS service.
    goto :EOF
)
echo [%mydate% %mytime%] IIS service stopped. >> %logFile%
echo IIS service stopped.

:: Define directories to clean
set "dirs=C:\Windows\SystemTemp C:\Windows\Temp C:\Users\Administrator\Local\Temp"

:: Delete files in specified directories
for %%d in (%dirs%) do (
    echo Deleting files in %%d...
    echo [%mydate% %mytime%] Deleting files in %%d... >> %logFile%
    for %%f in (%%d\*) do (
        del /F /Q "%%f" 2>> %logFile% || (
            echo [%mydate% %mytime%] Could not delete %%f, skipping... >> %logFile%
            echo Could not delete %%f, skipping...
        )
    )
)
echo [%mydate% %mytime%] File deletion completed. >> %logFile%
echo File deletion completed.

:: Start IIS service
echo Starting IIS service...
echo [%mydate% %mytime%] Starting IIS service... >> %logFile%
net start w3svc >> %logFile% 2>&1
if '%errorlevel%' NEQ '0' (
    echo [%mydate% %mytime%] Failed to start IIS service. >> %logFile%
    echo Failed to start IIS service.
    goto :EOF
)
echo [%mydate% %mytime%] IIS service started. >> %logFile%
echo IIS service started.

:: Check IIS service status
echo Checking IIS service status on ports 80 and 443...
echo [%mydate% %mytime%] Checking IIS service status on ports 80 and 443... >> %logFile%
netstat -an | findstr ":80 :443" >> %logFile%

echo [%mydate% %mytime%] Script ended. >> %logFile%
echo Script ended.

endlocal
exit /b
