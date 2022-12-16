:: Collection of utility functions to display messages to terminal

@echo off
call :%*
exit /b %errorlevel%

:echo_red
    echo [91m%~1[0m
    exit /b 0

:echo_green
    echo [92m%~1[0m
    exit /b 0

:echo_yellow
    echo [93m%~1[0m
    exit /b 0

:echo_blue
    echo [94m%~1[0m
    exit /b 0

:echo_magenta
    echo [95m%~1[0m
    exit /b 0

:echo_cyan
    echo [96m%~1[0m
    exit /b 0

:sound_success
    call powershell [console]::beep(750,150), [console]::beep(750,150), [console]::beep(750,150)
    exit /b 0

:sound_error
    call powershell [console]::beep(350,450), [console]::beep(250,550)
    exit /b 0

:task_finished
    set original_error_level=%1
    echo.
    if %original_error_level% EQU 0 (
        call :sound_success
	    call :echo_blue "Done..."
        
    ) else (
        call :sound_error
        call :echo_red "Error %original_error_level%..."
        
    )
    echo.
    pause
    exit /b %original_error_level%