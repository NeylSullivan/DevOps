:: Generate Visual Studio solution

call "%~dp0\Core\config.bat"

@echo on

call "%BATCH_FILES_PATH%\Build.bat" -projectfiles -project="%PROJECT_FILE_PATH%" -game -rocket -progress 

call %UTILS_PATH% task_finished %errorlevel%