@ECHO OFF
CLS
IF "%~1" == "2" GOTO update_install
IF "%~1" == "3" GOTO update_finish
IF NOT "%~1" == "1" EXIT
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_new_version% - Update

ECHO. & ECHO Downloading update...
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :update_remove_job "%%G"
BITSADMIN /CANCEL "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" > NUL 2>&1
PING github.com -n 1 -w 5000 > NUL 2>&1 || GOTO update_failed
BITSADMIN /CREATE /DOWNLOAD "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" > NUL 2>&1
BITSADMIN /SETMAXDOWNLOADTIME "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" 20 > NUL 2>&1
BITSADMIN /SETNOPROGRESSTIMEOUT "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" 5 > NUL 2>&1
BITSADMIN /SETMINRETRYDELAY "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" 0 > NUL 2>&1
BITSADMIN /SETNOTIFYCMDLINE "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" NULL NULL > NUL 2>&1
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_new_version% - Downloading Update
MKDIR "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1 || GOTO update_failed
BITSADMIN /TRANSFER "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" /DOWNLOAD /DYNAMIC "https://github.com/BigRedBrent/CloudCoinDesktopPortable/raw/main/CloudCoinDesktopPortable.zip" "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp\CloudCoinDesktopPortable.zip"
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_new_version% - Update
BITSADMIN /CANCEL "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" > NUL 2>&1
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :update_remove_job "%%G"
GOTO update_skip_remove_job
:update_remove_job
SET CLOUDCOINDESKTOPPORTABLE_update_guid=%~1
ECHO %~1 | FIND "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" > NUL 2>&1 && BITSADMIN /CANCEL %CLOUDCOINDESKTOPPORTABLE_update_guid:~0,38% > NUL 2>&1
EXIT /B
:update_skip_remove_job
CLS
IF NOT EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp\CloudCoinDesktopPortable.zip" GOTO update_failed

ECHO. & ECHO Checking downloaded update...
CD /D "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp"
"%CLOUDCOINDESKTOPPORTABLE_home_dir%\Scripts\7za.exe" t CloudCoinDesktopPortable.zip -r > NUL 2>&1 || GOTO update_failed
CLS & ECHO. & ECHO Extracting update...
"%CLOUDCOINDESKTOPPORTABLE_home_dir%\Scripts\7za.exe" x CloudCoinDesktopPortable.zip > NUL 2>&1 || GOTO update_failed
IF NOT EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Desktop Portable\Scripts\update.cmd" GOTO update_failed

COPY /Y "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Desktop Portable\Scripts\update.cmd" "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 || GOTO update_failed
FC /B "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Desktop Portable\Scripts\update.cmd" "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 || GOTO update_failed
CD /D "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings"
START "" update.tmp.cmd "2" & EXIT

:update_install
CALL "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Desktop Portable\Start CloudCoin Desktop Portable.cmd" "1"
SET CLOUDCOINDESKTOPPORTABLE_new_version=%CLOUDCOINDESKTOPPORTABLE_version%
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_new_version% - Update
CLS & ECHO. & ECHO Installing update...
IF NOT EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\replaced.tmp\" MKDIR "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\replaced.tmp" > NUL 2>&1 || GOTO update_failed
MOVE /Y "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Scripts" "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\replaced.tmp\" > NUL 2>&1 || GOTO update_failed
MOVE /Y "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Desktop Portable\Scripts" "%CLOUDCOINDESKTOPPORTABLE_home_dir%\" > NUL 2>&1 || GOTO update_failed
CD /D "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Scripts"
START "" update.cmd "3" & EXIT

:update_finish
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_new_version% - Update
CLS & ECHO. & ECHO Installing update...
FOR %%G IN ("vbs","cmd") DO MOVE /Y "%CLOUDCOINDESKTOPPORTABLE_home_dir%\*.%%~G" "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\replaced.tmp\" > NUL 2>&1
MOVE /Y "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Desktop Portable\*" "%CLOUDCOINDESKTOPPORTABLE_home_dir%\" > NUL 2>&1 || GOTO update_failed

DEL "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1
RMDIR /S /Q "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1
RMDIR /S /Q "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\replaced.tmp" > NUL 2>&1
ECHO %CLOUDCOINDESKTOPPORTABLE_new_version% %DATE:~-10% %TIME: =0%> "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\version.txt"
START "" notepad.exe "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Changelog.txt"
EXIT

:update_failed
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_new_version% - Failed
ECHO.
ECHO Update failed!
ECHO.
RMDIR /S /Q "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1
DEL "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 & PAUSE & EXIT
