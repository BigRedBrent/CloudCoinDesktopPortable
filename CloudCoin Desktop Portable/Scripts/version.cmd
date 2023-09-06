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
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :version_remove_job "%%G"
BITSADMIN /CANCEL "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" > NUL 2>&1
PING github.com -n 1 -w 5000 > NUL 2>&1 || GOTO version_done
BITSADMIN /CREATE /DOWNLOAD "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" > NUL 2>&1
BITSADMIN /SETMAXDOWNLOADTIME "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" 20 > NUL 2>&1
BITSADMIN /SETNOPROGRESSTIMEOUT "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" 5 > NUL 2>&1
BITSADMIN /SETMINRETRYDELAY "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" 0 > NUL 2>&1
BITSADMIN /SETNOTIFYCMDLINE "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" NULL NULL > NUL 2>&1
BITSADMIN /TRANSFER "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" /DOWNLOAD /DYNAMIC "https://github.com/BigRedBrent/CloudCoinDesktopPortable/raw/main/version.txt" "%CLOUDCOINDESKTOPPORTABLE_home_dir%\Settings\version.tmp" > NUL 2>&1
BITSADMIN /CANCEL "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" > NUL 2>&1
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :version_remove_job "%%G"
GOTO version_skip_remove_job
:version_remove_job
SET CLOUDCOINDESKTOPPORTABLE_version_guid=%~1
ECHO %~1 | FIND "%CLOUDCOINDESKTOPPORTABLE_name% Download Update" > NUL 2>&1 && BITSADMIN /CANCEL %CLOUDCOINDESKTOPPORTABLE_version_guid:~0,38% > NUL 2>&1
EXIT /B
:version_skip_remove_job
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
