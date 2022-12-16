:: Rebuild solution for editor

call "%~dp0\Core\config.bat"

call "%BATCH_FILES_PATH%\Rebuild.bat"  "%PROJECT_FILE_NAME%Editor" Win64 Development -Project="%PROJECT_FILE_PATH%" -WaitMutex

call %UTILS_PATH% task_finished %errorlevel%