IF "%~1" == "" EXIT

IF NOT EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\" MKDIR "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings" > NUL 2>&1 || GOTO version_done
IF EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp\" RMDIR /S /Q "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1 || GOTO version_done
IF EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp.cmd" DEL "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 || GOTO version_done
CALL :version_done
IF DEFINED CLOUDCOINDESKTOPPORTABLE_no_version_check GOTO version_done
IF NOT EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\version.txt" GOTO version_start
FOR %%G IN ("%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\version.txt") DO SET CLOUDCOINDESKTOPPORTABLE_file_date=%%~tG
IF "%CLOUDCOINDESKTOPPORTABLE_file_date:~0,10%" == "%DATE:~-10%" IF NOT "%CLOUDCOINDESKTOPPORTABLE_file_date:~0,10%" == "" GOTO version_done

:version_start
TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_version% - Checking Version
SET CLOUDCOINDESKTOPPORTABLE_new_version=
CALL :version_done
ECHO. & ECHO Checking for update...
WHERE powershell >NUL 2>&1 || GOTO version_done
powershell -Command "$ErrorActionPreference = 'Stop';" "try { Invoke-WebRequest -Uri 'https://github.com/BigRedBrent/CloudCoinDesktopPortable/raw/main/version.txt' -TimeoutSec 5 -OutFile '%CLOUDCOINDESKTOPPORTABLE_home_dir%\\Settings\\version.tmp' } catch { exit 1 }" || GOTO version_done

CLS
IF NOT EXIST "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\version.tmp" GOTO version_done

CD /D "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings"
FOR /F "tokens=* delims=" %%G in (version.tmp) DO IF NOT "%%~G" == "" CALL :set_version "%%~G" & GOTO skip_version
GOTO skip_version
:set_version
SET CLOUDCOINDESKTOPPORTABLE_new_version=%~1
EXIT /B
:skip_version
CD /D "%~dp0"

CALL :version_done

IF "%CLOUDCOINDESKTOPPORTABLE_new_version%" == "" GOTO version_done
IF NOT "%CLOUDCOINDESKTOPPORTABLE_version%" == "%CLOUDCOINDESKTOPPORTABLE_new_version%" GOTO version_next
ECHO %CLOUDCOINDESKTOPPORTABLE_version% %DATE:~-10% %TIME: =0%> "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\version.txt"
GOTO version_done
:version_next

TITLE %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_version%
:version_redo_choice
CLS
ECHO. & ECHO Update available: %CLOUDCOINDESKTOPPORTABLE_name% %CLOUDCOINDESKTOPPORTABLE_new_version% & ECHO.
CHOICE /C 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ /M "Download and update [Y/N]?" /N
IF %ERRORLEVEL% == 24 GOTO version_done
IF NOT %ERRORLEVEL% == 35 GOTO version_redo_choice
CALL update.cmd "1"

:version_done
DEL /Q "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\*.tmp" > NUL 2>&1
DEL /A:H /Q "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\*.tmp" > NUL 2>&1
EXIT /B
