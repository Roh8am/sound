@ECHO OFF
cls

REM Code build location
if "%~1"=="" GOTO MISSING_PARAMETERS			

REM Code deploy base path
if "%~2"=="" GOTO MISSING_PARAMETERS

REM Code back up path
if "%~3"=="" GOTO MISSING_PARAMETERS 

SET BackupPath=%3
SET Location=%1
SET zipUtility="C:\Program Files\7-Zip\7z.exe"


SET InternalSites=%2\inetpub\FrontierSites

SET deployFrontierWallBoardMobile=%Location%\deployFrontierWallBoardMobile.bat


IF EXIST %deployFrontierWallBoardMobile% DEL /F %deployFrontierWallBoardMobile%

:BUILD_CODE
	ECHO Build Code
    docker build^
        --rm -t frontierwallboardmobile^
        -f Dockerfile .
	IF NOT ERRORLEVEL 1 GOTO PUBLISH_CODE
	ECHO ===                                                                         ===
	ECHO ===      There is an error to build code in container and deployment will   ===
    ECHO ===      be terminated. No changes will apply to system.                    ===
	ECHO ===                                                                         ===
	
	GOTO PROCESS_FAILED
	
:PUBLISH_CODE
	ECHO Publish Code
    docker run --rm --name frontierwallboardmobile-UAT --entrypoint C:\output\sync.cmd -v %Location%:C:\output frontierwallboardmobile:latest

:PREPARE_BATCH
	for /f "tokens=2,3,4 delims=/ " %%i in ('echo %date%') do (
	set year=%%k
	set month=%%i
	set day=%%j
	)
	
	ECHO Build Deploy Batch File
    REM CreateFrontierWallBoardMobile deploy batch file
    ECHO @ECHO OFF > %deployFrontierWallBoardMobile%
    ECHO %zipUtility% a %BackupPath%\FrontierWallBoardMobile-%year%-%month%-%day%.zip "%internalsites%\WallBoard">> %deployFrontierWallBoardMobile%
    ECHO robocopy "%Location%\Application\FrontierWallBoardMobile" "%internalsites%\WallBoard" /E /Z /ZB /R:5 /W:5 /TBD /NP /V /XF *.config>> %deployFrontierWallBoardMobile%

 
	

	
:END
    exit 0

:MISSING_PARAMETERS
    ECHO Missing release parameters value
    exit 1
	
:PROCESS_FAILED
	exit 1