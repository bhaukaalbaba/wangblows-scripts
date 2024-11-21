@echo off
setlocal enabledelayedexpansion

set log_file=%temp%\sxscleanup.log
set timestamp=%date% %time:~0,8%

:initialize
cls
echo Initializing...
echo Initializing... >> %log_file%
goto :main_menu

:main_menu
cls
echo Select an option:
echo 1. StartComponentCleanup
echo 2. StartComponentCleanup with ResetBase
echo 3. SPSuperseded
echo 4. Silent mode (all tasks)
echo 5. Help
echo 6. Exit
set /p choice=Choose an option:

if "!choice!"=="1" call :StartComponentCleanup
if "!choice!"=="2" call :StartComponentCleanup_ResetBase
if "!choice!"=="3" call :SPSuperseded
if "!choice!"=="4" goto :silent_mode
if "!choice!"=="5" goto :show_help
if "!choice!"=="6" goto :exit_script

goto :main_menu

:StartComponentCleanup
@echo on
echo !timestamp!: Running StartComponentCleanup... >> %log_file%
Dism.exe /online /Cleanup-Image /StartComponentCleanup >> %log_file% 2>&1
if !errorlevel! neq 0 (
    echo !timestamp!: Failed to run StartComponentCleanup. See %log_file% for details.
    pause
    goto :eof
)
@echo off
goto :main_menu

:StartComponentCleanup_ResetBase
@echo on
echo !timestamp!: Running StartComponentCleanup with ResetBase... >> %log_file%
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase >> %log_file% 2>&1
if !errorlevel! neq 0 (
    echo !timestamp!: Failed to run StartComponentCleanup with ResetBase. See %log_file% for details.
    pause
    goto :eof
)
@echo off
goto :main_menu

:SPSuperseded
@echo on
echo !timestamp!: Running SPSuperseded... >> %log_file%
Dism.exe /online /Cleanup-Image /SPSuperseded >> %log_file% 2>&1
if !errorlevel! neq 0 (
    echo !timestamp!: Failed to run SPSuperseded. See %log_file% for details.
    pause
    goto :eof
)
@echo off
goto :main_menu

:silent_mode
@echo on
echo !timestamp!: Running silent mode... >> %log_file%
Dism.exe /online /Cleanup-Image /StartComponentCleanup >> %log_file% 2>&1
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase >> %log_file% 2>&1
Dism.exe /online /Cleanup-Image /SPSuperseded >> %log_file% 2>&1
if !errorlevel! neq 0 (
    echo !timestamp!: Failed to run one or more tasks in silent mode. See %log_file% for details.
    pause
    goto :eof
)
@echo off
goto :eof

:show_help
cls
echo Help:
echo 1. StartComponentCleanup: Cleans up superseded components to reduce space.
echo 2. StartComponentCleanup with ResetBase: Cleans up and resets base component store.
echo 3. SPSuperseded: Removes superseded Service Pack files.
echo 4. Silent mode: Runs all cleanup tasks without user intervention.
echo Press any key to return to the main menu.
pause > nul
goto :main_menu

:exit_script
echo Cleaning up and exiting...
echo Cleaning up and exiting... >> %log_file%
goto :eof

:eof
endlocal
exit /b
