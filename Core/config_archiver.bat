:: Core file executed by backup scripts only.
:: - Call `config.bat` first
:: - Set archive file suffix based on current date and time
:: - Set `7z.exe` path
:: - Set backup dir path
::
:: ***TODO - read `%BACKUP_ROOT_DIR%` from config file. Current value is `e:\DATA\Backups`***

@echo off
call "%~dp0\config.bat"

rem Info for archiver
set year=%date:~-4,4%
set month=%date:~-7,2%
set day=%date:~-10,2%
set hour=%time:~-11,2%
set hour=%hour: =0%
set min=%time:~-8,2%

set datetime=%year%.%month%.%day%.%hour%%min%
call "%UTILS_PATH%" echo_blue "Date Time for archiver: %datetime%"

set ArchiverExePath="%ProgramFiles(x86)%\7-Zip\7z.exe"
if not exist %ArchiverExePath% set ArchiverExePath="%ProgramFiles%\7-Zip\7z.exe"

rem TODO - read from config file
set BACKUP_ROOT_DIR=e:\DATA\Backups
