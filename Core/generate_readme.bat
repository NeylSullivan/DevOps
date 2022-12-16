:: Launch script for `generate_readme.py`
:: If launched with argument (should be directory path), pass it as script `--dir` argument (override root scan dir),
:: otherwise launch `generate_readme.py` without any arguments (in default mode will scan directory one level up)

@echo off

REM Check for Python Installation
call python --version 2
if errorlevel 1 goto errorNoPython

if [%1]==[] (Python.exe "%~dp0\generate_readme.py") else (Python.exe "%~dp0\generate_readme.py" --dir %1)

call "%~dp0\utils.bat" task_finished %errorlevel%
goto:eof

:errorNoPython
echo.
echo Error^: Python not installed
pause