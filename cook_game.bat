:: Build game with cooked content

call "%~dp0\Core\config.bat"

call "%RUN_UAT_PATH%" BuildCookRun -nocompileeditor -installed -nop4 ^
-project="%PROJECT_FILE_PATH%" ^
-platform=Win64 ^
-clientconfig=Shipping ^
-build -cook -stage -SkipCookingEditorContent -pak -prereqs -nodebuginfo -noturnkeyvariables

call %UTILS_PATH% task_finished %errorlevel%