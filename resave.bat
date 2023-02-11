:: Resave current project packages, fix redirectors
call "%~dp0\Core\config.bat"

call "%EDITOR_CMD_PATH%" "%PROJECT_FILE_PATH%" -run=ResavePackages -fixupredirects -autocheckout -projectonly -unattended

call %UTILS_PATH% task_finished %errorlevel%