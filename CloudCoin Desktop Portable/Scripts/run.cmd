IF "%~1" == "" EXIT
CLS
IF EXIST "..\Start CloudCoin Desktop Portable.cmd" FOR %%G IN ("..\*.cmd") DO IF /I NOT "%%~nG" == "Start CloudCoin Desktop Portable" (DEL "%%~fG" > NUL 2>&1 & SET CLOUDCOINDESKTOPPORTABLE_home_dir=)
IF "%CLOUDCOINDESKTOPPORTABLE_home_dir%" == "" EXIT
SET CLOUDCOINDESKTOPPORTABLE_client_name_ext=%~nx1
TASKLIST /FI "imagename eq %CLOUDCOINDESKTOPPORTABLE_client_name_ext%" | FIND "%CLOUDCOINDESKTOPPORTABLE_client_name_ext%" > NUL && CALL error.cmd "CloudCoin Desktop is already running!" "4"
CALL version.cmd "1"
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_version%
CLS

SET CLOUDCOINDESKTOPPORTABLE_local_manager_dir=%~dp1
IF "%CLOUDCOINDESKTOPPORTABLE_local_manager_dir:~-1%" == "\" SET CLOUDCOINDESKTOPPORTABLE_local_manager_dir=%CLOUDCOINDESKTOPPORTABLE_local_manager_dir:~0,-1%

FOR %%G IN (%*) DO IF EXIST "%%~fG" (
    SET CLOUDCOINDESKTOPPORTABLE_manager=%%~fG
    SET CLOUDCOINDESKTOPPORTABLE_manager_dir=%%~dpG
    GOTO manager_found
)
CALL error.cmd "CloudCoin Desktop not installed!"
:manager_found
IF "%CLOUDCOINDESKTOPPORTABLE_manager_dir:~-1%" == "\" SET CLOUDCOINDESKTOPPORTABLE_manager_dir=%CLOUDCOINDESKTOPPORTABLE_manager_dir:~0,-1%
IF EXIST "%CLOUDCOINDESKTOPPORTABLE_local_manager_dir%\" GOTO no_copy_manager
CALL copy.cmd "%CLOUDCOINDESKTOPPORTABLE_manager_dir%" "%CLOUDCOINDESKTOPPORTABLE_local_manager_dir%" "Copy CloudCoin Desktop to portable folder [Y/N]?" "Copying manager files..." "Verifying copied manager files..." "Failed to copy manager files!"
IF %ERRORLEVEL% EQU 1 EXIT
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_version%
CLS
:no_copy_manager

DEL "%~f1.tmp" > NUL 2>&1
IF NOT EXIST "%~f1" GOTO no_update_manager
FOR %%G IN (%*) DO IF NOT "%%~tG" == "%~t1" IF EXIST "%%~fG" (
    SET CLOUDCOINDESKTOPPORTABLE_new_manager=%%~fG
    SET CLOUDCOINDESKTOPPORTABLE_new_manager_dir=%%~dpG
    GOTO new_manager_found
)
GOTO no_update_manager
:new_manager_found
COPY /Y "%CLOUDCOINDESKTOPPORTABLE_new_manager%" "%~f1.tmp" > NUL 2>&1
CD /D "%~dp1"
FOR /F %%G IN ('DIR /B /O:-D "%~nx1" "%~nx1.tmp"') DO (
    DEL "%~f1.tmp" > NUL 2>&1
    CD /D "%~dp0"
    IF "%%~nxG" == "%~nx1" GOTO no_update_manager
    GOTO manager_update_found
)
:manager_update_found
IF "%CLOUDCOINDESKTOPPORTABLE_new_manager_dir:~-1%" == "\" SET CLOUDCOINDESKTOPPORTABLE_new_manager_dir=%CLOUDCOINDESKTOPPORTABLE_new_manager_dir:~0,-1%
CALL copy.cmd "%CLOUDCOINDESKTOPPORTABLE_new_manager_dir%" "%CLOUDCOINDESKTOPPORTABLE_local_manager_dir%" "Replace CloudCoin Desktop in portable folder with newer installed version [Y/N]?" "Copying manager files..." "Verifying copied manager files..." "Failed to copy manager files!"
IF %ERRORLEVEL% EQU 1 EXIT
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_version%
CLS
:no_update_manager

SET CLOUDCOINDESKTOPPORTABLE_userprofile_settings_dir=%USERPROFILE%\cloudcoin_desktop
SET CLOUDCOINDESKTOPPORTABLE_local_userprofile_settings_dir=%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\cloudcoin_desktop
SET CLOUDCOINDESKTOPPORTABLE_appdata_settings_dir=%APPDATA%\%CLOUDCOINDESKTOPPORTABLE_client_name_ext%
SET CLOUDCOINDESKTOPPORTABLE_local_appdata_settings_dir=%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\AppData\Roaming\%CLOUDCOINDESKTOPPORTABLE_client_name_ext%

IF NOT EXIST "%CLOUDCOINDESKTOPPORTABLE_local_userprofile_settings_dir%\" MKDIR "%CLOUDCOINDESKTOPPORTABLE_local_userprofile_settings_dir%" || EXIT
IF NOT EXIST "%CLOUDCOINDESKTOPPORTABLE_local_appdata_settings_dir%\" MKDIR "%CLOUDCOINDESKTOPPORTABLE_local_appdata_settings_dir%" || EXIT

IF NOT EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Wallets\" IF EXIST "%CLOUDCOINDESKTOPPORTABLE_local_userprofile_settings_dir%\Wallets\" MOVE /Y "%CLOUDCOINDESKTOPPORTABLE_local_userprofile_settings_dir%\Wallets" "%CLOUDCOINDESKTOPPORTABLE_home_dir%\" > NUL 2>&1 || EXIT
IF NOT EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Wallets\" MKDIR "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Wallets" || EXIT

IF NOT EXIST "%CLOUDCOINDESKTOPPORTABLE_local_userprofile_settings_dir%\" MKDIR "%CLOUDCOINDESKTOPPORTABLE_local_userprofile_settings_dir%" || EXIT
IF NOT EXIST "%CLOUDCOINDESKTOPPORTABLE_local_userprofile_settings_dir%\locations.txt" GOTO create_location_file
CD /D "%CLOUDCOINDESKTOPPORTABLE_local_userprofile_settings_dir%"
SET CLOUDCOINDESKTOPPORTABLE_locations_txt=
FOR /f "delims=" %%a IN ('TYPE locations.txt') DO (
    SET CLOUDCOINDESKTOPPORTABLE_locations_txt=%%a
    GOTO test_location_file
)
:test_location_file
CD /D "%~dp0"
IF "%CLOUDCOINDESKTOPPORTABLE_locations_txt%" == "+%CLOUDCOINDESKTOPPORTABLE_home_dir%\Wallets" GOTO skip_location_file
IF "%CLOUDCOINDESKTOPPORTABLE_locations_txt%" == "-%CLOUDCOINDESKTOPPORTABLE_home_dir%\Wallets" GOTO skip_location_file
IF "%CLOUDCOINDESKTOPPORTABLE_locations_txt%" == "+%CLOUDCOINDESKTOPPORTABLE_home_dir%\Wallets " GOTO skip_location_file
IF "%CLOUDCOINDESKTOPPORTABLE_locations_txt%" == "-%CLOUDCOINDESKTOPPORTABLE_home_dir%\Wallets " GOTO skip_location_file
:create_location_file
ECHO +%CLOUDCOINDESKTOPPORTABLE_home_dir%\Wallets> "%CLOUDCOINDESKTOPPORTABLE_local_userprofile_settings_dir%\locations.txt" || EXIT
:skip_location_file

SET APPDATA=%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\AppData\Roaming
SET CLOUDCOINDESKTOPPORTABLE_scripts_dir=
IF EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\custom_end.cmd" SET CLOUDCOINDESKTOPPORTABLE_scripts_dir=%CLOUDCOINDESKTOPPORTABLE_home_dir%\Scripts
IF EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\custom.cmd" (
    CD /D "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings"
    CALL custom.cmd "1"
    CD /D "%~dp0"
)
START "" wait.vbs "%CLOUDCOINDESKTOPPORTABLE_manager_dir%" "%CLOUDCOINDESKTOPPORTABLE_manager%" "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings" "%CLOUDCOINDESKTOPPORTABLE_scripts_dir%"
EXIT
