@ECHO OFF
CLS
IF "%~1" == "2" GOTO update_install
IF "%~1" == "3" GOTO update_finish
IF NOT "%~1" == "1" EXIT
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_new_version% - Update

ECHO. & ECHO Downloading update...
WHERE powershell >NUL 2>&1 || GOTO update_failed
MKDIR "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1 || GOTO update_failed
powershell -Command "$ErrorActionPreference = 'Stop'; try { Invoke-WebRequest -Uri 'https://github.com/BigRedBrent/CloudCoinDesktopPortable/raw/main/CloudCoinDesktopPortable.zip' -TimeoutSec 10 -OutFile '%CLOUDCOINDESKTOPPORTABLE_home_dir%\\Settings\\update.tmp\\CloudCoinDesktopPortable.zip' } catch { exit 1 }" || GOTO update_failed

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
