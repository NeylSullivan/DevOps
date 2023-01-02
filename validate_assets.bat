:: Perform command line assetd validation

call "%~dp0\Core\config.bat"

call "%EDITOR_CMD_PATH%" "%PROJECT_FILE_PATH%" -run=DataValidation

call %UTILS_PATH% task_finished %errorlevel%