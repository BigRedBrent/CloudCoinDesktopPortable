@ECHO OFF

SET CLOUDCOINDESKTOPPORTABLE_version=1.0
SET CLOUDCOINDESKTOPPORTABLE_name=CloudCoin Desktop Portable
SET CLOUDCOINDESKTOPPORTABLE_no_version_check=

IF NOT "%~1" == "" EXIT /B
TASKLIST /FI "imagename eq cmd.exe" /FO list /V | FIND "%CLOUDCOINDESKTOPPORTABLE_name%" > NUL && EXIT
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_version%
SET CLOUDCOINDESKTOPPORTABLE_home_dir=%~dp0
IF "%CLOUDCOINDESKTOPPORTABLE_home_dir:~0,2%" == "\\" ECHO. & ECHO. & ECHO     Unable to run CloudCoin Desktop Portable from a network share! & ECHO. & ECHO. & PAUSE & EXIT
IF "%CLOUDCOINDESKTOPPORTABLE_home_dir:~-1%" == "\" SET CLOUDCOINDESKTOPPORTABLE_home_dir=%CLOUDCOINDESKTOPPORTABLE_home_dir:~0,-1%
SET CLOUDCOINDESKTOPPORTABLE_manager_list="%CLOUDCOINDESKTOPPORTABLE_home_dir%\CloudCoin Desktop\cloudcoin_desktop\cloudcoin_desktop.exe"
SET CLOUDCOINDESKTOPPORTABLE_manager_list=%CLOUDCOINDESKTOPPORTABLE_manager_list% "%ProgramFiles(x86)%\CloudCoin Consortium\CloudCoin Desktop\cc_safe\cloudcoin_desktop.exe"
SET CLOUDCOINDESKTOPPORTABLE_manager_list=%CLOUDCOINDESKTOPPORTABLE_manager_list% "%ProgramFiles%\CloudCoin Consortium\CloudCoin Desktop\cc_safe\cloudcoin_desktop.exe"
IF EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\custom_start.cmd" (
    CD /D "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings"
    CALL custom_start.cmd "1"
)
CD /D "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Scripts"
CALL run.cmd %CLOUDCOINDESKTOPPORTABLE_manager_list%
EXIT
