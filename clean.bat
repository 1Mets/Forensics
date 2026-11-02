@echo off
setlocal enabledelayedexpansion
cls
sc stop dps >nul 2>&1
sc stop sysmain >nul 2>&1
sc stop pcasvc >nul 2>&1
sc stop eventlog >nul 2>&1
sc stop bam >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1

del "%windir%\system32\sru\*" /q >nul 2>&1
del "%windir%\prefetch\*" /q >nul 2>&1
del "%AppData%\Microsoft\Windows\Recent\*" /f /q >nul 2>&1
del "%AppData%\Microsoft\Windows\Recent\AutomaticDestinations\*" /f /q >nul 2>&1
del "%AppData%\Microsoft\Windows\Recent\CustomDestinations\*" /f /q >nul 2>&1
del "%temp%\*" /f /s /q >nul 2>&1
del "%systemroot%\Temp\*" /f /s /q >nul 2>&1
del "%ProgramData%\Microsoft\Windows\WER\ReportArchive\*" /f /s /q >nul 2>&1
del "%LocalAppData%\CrashDumps\*" /f /q >nul 2>&1
del "%windir%\appcompat\Programs\*" /f /q /a >nul 2>&1
del "%AppData%\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" /f /q /a >nul 2>&1
del "%windir%\System32\winevt\Logs\*" /f /q /a >nul 2>&1

taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im brave.exe >nul 2>&
1taskkill /f /im msedge.exe >nul 2>&1
for %%B in (
    "%LOCALAPPDATA%\Google\Chrome\User Data"
    "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data"
    "%LOCALAPPDATA%\Microsoft\Edge\User Data"
) do (
    if exist "%%~B" (
        for /r "%%~B" %%i in (*) do (
            if /i "%%~nxi"=="History" del "%%i" /f /q
        )
    )
)


(
    echo \Registry\Machine\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings [1 17]
    for /f "tokens=*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings"') do (
        set "KEY=%%A"
        set "KEY_REL=!KEY:HKEY_LOCAL_MACHINE\=!"
        echo \Registry\Machine\!KEY_REL! [1 17]
    )
) > "%TEMP%\bam_perms.txt"
regini "%TEMP%\bam_perms.txt" >nul 2>&1

for /f "tokens=*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings"') do (
    reg delete "%%A" /f >nul 2>&1
)

(
    echo \Registry\Machine\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings [2 17]
    for /f "tokens=*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings"') do (
        set "KEY=%%A"
        set "KEY_REL=!KEY:HKEY_LOCAL_MACHINE\=!"
        echo \Registry\Machine\!KEY_REL! [2 17]
    )
) > "%TEMP%\bam_restore.txt"
regini "%TEMP%\bam_restore.txt" >nul 2>&1

del "%TEMP%\bam_perms.txt" >nul 2>&1
del "%TEMP%\bam_restore.txt" >nul 2>&1

ipconfig /flushdns >nul 2>&1

reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache" /v AppCompatCache /f >nul 2>&1
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /va /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /va /f >nul 2>&1

explorer.exe
rundll32.exe apphelp.dll,ShimFlushCache
fsutil usn deletejournal /D C: >nul 2>&1

endlocal
pause
