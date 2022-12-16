:: Core file executed by every script.
:: - Will find *.uproject file and set project name from it.
:: - Read Unreal Engine version from *.uproject.
:: - Find path in registry for this engine version.
:: - Set additional config vars.
::
:: ***TODO - should be rewritten with python.***

@echo off
cls

rem full path to utils.bat to call it from other script if working directory changed
for %%F in ("%~dp0\utils.bat") do set UTILS_PATH=%%~dpnxF

rem PROJECT_ROOT_PATH go too levels up
for %%G in ("%~dp0\..\..") do set PROJECT_ROOT_PATH=%%~dpnxG

echo.
call "%UTILS_PATH%" echo_blue "PROJECT_ROOT_PATH: %PROJECT_ROOT_PATH%"

rem PROJECT_ROOT_NAME extracted from PROJECT_ROOT_PATH
for /f "delims==" %%F in ("%PROJECT_ROOT_PATH%") do set PROJECT_ROOT_NAME=%%~nF

call "%UTILS_PATH%" echo_blue "PROJECT_ROOT_NAME: %PROJECT_ROOT_NAME%"

rem PROJECT_FILE_PATH we asume only one uproject file exist
for %%F in (%PROJECT_ROOT_PATH%\*.uproject) do if "%%~xF"==".uproject" set PROJECT_FILE_PATH=%%F
call "%UTILS_PATH%" echo_blue "PROJECT_FILE_PATH: %PROJECT_FILE_PATH%"

rem PROJECT_FILE_NAME - actual uproject file name
for %%F in (%PROJECT_FILE_PATH%) do set PROJECT_FILE_NAME=%%~nF
call "%UTILS_PATH%" echo_blue "PROJECT_FILE_NAME: %PROJECT_FILE_NAME%"

rem Get from *.uproject file
for /f %%F in ('Powershell -Nop -C "(Get-Content "%PROJECT_FILE_PATH%"|ConvertFrom-Json).EngineAssociation"') do set ENGINE_ASSOCIATION=%%F
call "%UTILS_PATH%" echo_blue "ENGINE_ASSOCIATION: %ENGINE_ASSOCIATION%"


rem Get from registry based on ENGINE_ASSOCIATION
set ENGINE_REGISTRY_PATH=HKLM\SOFTWARE\EpicGames\Unreal Engine\%ENGINE_ASSOCIATION%
call "%UTILS_PATH%" echo_blue "ENGINE_REGISTRY_PATH: %ENGINE_REGISTRY_PATH%"

for /f "tokens=2*" %%a in ('REG QUERY "%ENGINE_REGISTRY_PATH%" /v "InstalledDirectory"') do set "ENGINE_PATH=%%~b"
call "%UTILS_PATH%" echo_blue "ENGINE_PATH: %ENGINE_PATH%"


set EDITOR_PATH=%ENGINE_PATH%\Engine\Binaries\Win64\UnrealEditor.exe
set EDITOR_CMD_PATH=%ENGINE_PATH%\Engine\Binaries\Win64\UnrealEditor-Cmd.exe

set BATCH_FILES_PATH=%ENGINE_PATH%\Engine\Build\BatchFiles
set RUN_UAT_PATH=%ENGINE_PATH%\Engine\Build\BatchFiles\RunUAT.bat
