@echo off
setlocal

:: Set variables
set SERVER_NAME=localhost
set DATABASE_NAME=Focus8030
set BACKUP_PATH=D:\db_backups

:: Get current date and time with padding for single digits
for /f "tokens=2 delims==" %%A in ('"wmic os get localdatetime /value"') do set datetime=%%A
set year=%datetime:~0,4%
set month=0%datetime:~4,2%
set day=0%datetime:~6,2%
set hour=0%datetime:~8,2%
set minute=0%datetime:~10,2%
set month=%month:~-2%
set day=%day:~-2%
set hour=%hour:~-2%
set minute=%minute:~-2%

:: Define log file name
set logFile=D:\cleanuplogs\sqlbackup-log-%year%-%month%-%day%-%hour%-%minute%.log
echo Log file: %logFile%

:: Set backup file name
set BACKUP_FILE=%BACKUP_PATH%\backup-%year%-%month%-%day%.bak

:: Generate the SQL script dynamically
set SQL_SCRIPT=%TEMP%\backup_script.sql
echo BACKUP DATABASE [%DATABASE_NAME%] TO DISK = N'%BACKUP_FILE%' WITH NOFORMAT, NOINIT, NAME = N'%DATABASE_NAME%-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10 > %SQL_SCRIPT%

:: Run the SQL script with Windows Authentication and log output
sqlcmd -S %SERVER_NAME% -E -i %SQL_SCRIPT% > %logFile% 2>&1

:: Check if the SQL script ran successfully
if %errorlevel% equ 0 (
    echo Backup completed successfully. >> %logFile%
) else (
    echo Backup failed with error code %errorlevel%. >> %logFile%
)

:: Clean up
del %SQL_SCRIPT%

endlocal
@echo on
