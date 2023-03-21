@ECHO OFF
SET SOURCE=%~dp0

START "" /b /wait cmd /c "%SOURCE%_uninstall.cmd"
IF NOT %ERRORLEVEL%==0 ( ECHO Uninstallation failed: %ERRORLEVEL% ) ELSE ( ECHO Uninstallation completed successfully. )

ECHO.
PAUSE