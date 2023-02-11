:: Build game with cooked content

call "%~dp0\Core\config.bat"

REM First compile the editor targets to get up-to date versions of our editor dlls

call "%BATCH_FILES_PATH%\Build.bat"  "%PROJECT_FILE_NAME%Editor" Win64 Development -Project="%PROJECT_FILE_PATH%" -WaitMutex

call "%RUN_UAT_PATH%" BuildCookRun -nocompileeditor -installed -nop4 ^
-project="%PROJECT_FILE_PATH%" ^
-platform=Win64 ^
-clientconfig=Shipping ^
-build -cook -stage -SkipCookingEditorContent -pak -prereqs -nodebuginfo -noturnkeyvariables -NoSigh ^
-archive -archivedirectory="D:\Games\%PROJECT_FILE_NAME%"


call %UTILS_PATH% task_finished %errorlevel%