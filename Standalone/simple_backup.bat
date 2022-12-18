:: Simple standalone backup script. Archive file or folder provided as argument to 'BACKUPS' subdir.
:: Based on https://gist.github.com/adamcaudill/2322221
::
:: Installation:
::
:: - Windows+R
:: - `shell:sendto` to open `SendTo` directory
:: - Create shortcut to `simple_backup.bat` in `SendTo` directory
::
:: Using:
:: - Right click on file or folder and select `Send to - Simple Backup`
::

@echo on

set ArchiverExePath="%ProgramFiles(x86)%\7-Zip\7z.exe"
if not exist %ArchiverExePath% set ArchiverExePath="%ProgramFiles%\7-Zip\7z.exe"
if not exist %ArchiverExePath% goto notInstalled

rem Info for archiver
set year=%date:~-4,4%
set month=%date:~-7,2%
set day=%date:~-10,2%
set hour=%time:~-11,2%
set hour=%hour: =0%
set min=%time:~-8,2%

set datetime=%year%.%month%.%day%.%hour%%min%

set SOURCE=%~1
set BACKUP_FILE=%~dp1\BACKUPS\%~n1_Backup.%datetime%.7z

echo.
call :echo_green "Backing up '%SOURCE%' to '%BACKUP_FILE%'"
echo.

call %ArchiverExePath% a -t7z "%BACKUP_FILE%" "%SOURCE%"

if NOT %errorlevel% == 0 goto :error %errorlevel%
echo.

call :echo_green "'%SOURCE%' backed up to '%BACKUP_FILE%' is complete!"
goto end

:sound_success
    call powershell [console]::beep(750,150), [console]::beep(750,150), [console]::beep(750,150)
    exit /b 0

:sound_error
    call powershell [console]::beep(350,450), [console]::beep(250,550)
    exit /b 0

:echo_red
    echo [91m%~1[0m
    exit /b 0

:echo_green
    echo [92m%~1[0m
    exit /b 0

:error
    echo.
    call :echo_red "Error! %1"
    call :sound_error
    goto end


:notInstalled
    call :echo_red "Can not find 7-Zip"
    call :sound_error
    goto end

:end
    echo.
    PAUSE