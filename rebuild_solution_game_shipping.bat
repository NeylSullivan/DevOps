:: Rebuild solution for shipping

call "%~dp0\Core\config.bat"

call "%BATCH_FILES_PATH%\Rebuild.bat"  "%PROJECT_FILE_NAME%" Win64 Shipping -Project="%PROJECT_FILE_PATH%" -WaitMutex

call %UTILS_PATH% task_finished %errorlevel%