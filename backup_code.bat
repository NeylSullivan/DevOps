:: Simple and fast backup for c++ code. Save to 7z archive Source and Config folders from Project and Project Plugins.
:: Archive placed to `%BACKUP_ROOT_DIR%` defined in `DevOps\Core\config_archiver.bat` file (default - `e:\DATA\Backups`).

call "%~dp0\Core\config_archiver.bat"

if not exist %ArchiverExePath% goto notInstalled

echo off

set BACKUP_FILE=%BACKUP_ROOT_DIR%\%PROJECT_ROOT_NAME%_Backup\%PROJECT_ROOT_NAME%_Backup.%datetime%_Code.7z
echo.
call %UTILS_PATH% echo_green "Backing up '%PROJECT_ROOT_PATH%' to '%BACKUP_FILE%'"
echo.

cd %PROJECT_ROOT_PATH%

call %ArchiverExePath% a -t7z "%BACKUP_FILE%" *.* ^
-x!.vs\ ^
-i!Script\ ^
-i!DevOps\ ^
-i!Source\ ^
-i!Config\ ^
-i!Plugins\*\Source\ ^
-i!Plugins\*\Config\ ^
-i!Saved\Config\WindowsEditor\

if NOT %errorlevel% == 0 goto :error
echo.

call %UTILS_PATH% echo_green "%PROJECT_ROOT_PATH% backed up to %BACKUP_FILE% is complete!"
goto end

:error
echo.
call %UTILS_PATH% echo_red "Error! %errorlevel%"
goto end


:notInstalled
call %UTILS_PATH% echo_red "Can not find 7-Zip"
goto end

:end
echo.
call rundll32 user32.dll,MessageBeep
PAUSE