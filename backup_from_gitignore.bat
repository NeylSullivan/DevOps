:: Perform (almost) full backup of project.
:: - Stage 1. Create archive based on .gitignore in root project folder.
:: - Stage 2. Add extra files to archive (probably ignored by version control)
::   - Content dir
::   - *.DotSettings.user (Rider settings)
::   - .idea\ (Rider settings)
::   - Plugins Content, Config and Source dirs
::   - Saved\Config\WindowsEditor\ (local configs)
::
:: Archive placed to `%BACKUP_ROOT_DIR%` defined in `DevOps\Core\config_archiver.bat` file (default - `e:\DATA\Backups`)


call "%~dp0\Core\config_archiver.bat"

if not exist %ArchiverExePath% goto notInstalled

rem call "%EDITOR_CMD_PATH%" "%PROJECT_FILE_PATH%" -run=ResavePackages -fixupredirects -autocheckout -projectonly -unattended

echo off

set BACKUP_FILE=%BACKUP_ROOT_DIR%\%PROJECT_ROOT_NAME%_Backup\%PROJECT_ROOT_NAME%_Backup.%datetime%.7z
echo.
call %UTILS_PATH% echo_green "Backing up '%PROJECT_ROOT_PATH%' to '%BACKUP_FILE%'"
echo.

cd %PROJECT_ROOT_PATH%

rem Create archive based on .gitignore in root project folder
call %UTILS_PATH% echo_blue "First pass from .gitignore"
call %ArchiverExePath% a -t7z "%BACKUP_FILE%" * -x@.gitignore

if NOT %errorlevel% == 0 goto :error

rem Add extra files, not listed in .gitignore
call %UTILS_PATH% echo_blue "Second pass"
call %ArchiverExePath% u "%BACKUP_FILE%" Content\ ^
-i!*.DotSettings.user ^
-i!.idea\ ^
-i!Script\ ^
-i!Saved\Config\WindowsEditor\ ^
-i!Plugins\*\Source\ ^
-i!Plugins\*\Config\ ^
-i!Plugins\*\Content\

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