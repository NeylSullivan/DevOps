:: Manually generate python stub file for current project.
:: Generated file placed to
:: `%RootProjectDir%/Intermediate/PythonStub/unreal.py`
call "%~dp0\Core\config.bat"

call "%EDITOR_CMD_PATH%" "%PROJECT_FILE_PATH%" -run=PythonOnlineDocs -IncludeEngine -IncludeProject --no-warn-script-location

call %UTILS_PATH% task_finished %errorlevel%