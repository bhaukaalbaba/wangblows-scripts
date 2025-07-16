for %%f in ("C:\inetpub\logs\LogFiles\W3SVC1\*.log") do (
    "C:\Program Files\7-Zip\7z.exe" a -tgzip -mx=9 "%%~dpnf.gz" "%%f"
    if %ERRORLEVEL% EQU 0 del "%%f"
)
