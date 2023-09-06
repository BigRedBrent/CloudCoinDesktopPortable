@ECHO OFF
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_version%
IF "%~1" == "" EXIT
ECHO.
ECHO   CloudCoin Desktop is closing...
ECHO.
:client_running_check
TASKLIST /FI "imagename eq %CLOUDCOINDESKTOPPORTABLE_client_name_ext%" | FIND "%CLOUDCOINDESKTOPPORTABLE_client_name_ext%" > NUL || GOTO client_not_running
FOR %%G IN ("1") DO TIMEOUT /T %%~G /NOBREAK> NUL 2>&1 || PING -n %%~G 127.0.0.1 > NUL 2>&1 || PING -n %%~G ::1 > NUL 2>&1
GOTO client_running_check
:client_not_running
IF EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\custom_end.cmd" (
    CD /D "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings"
    CALL custom_end.cmd "1" & EXIT
)
EXIT
