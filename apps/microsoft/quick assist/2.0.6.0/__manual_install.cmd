@ECHO OFF
SET SOURCE=%~dp0

START "" /b /wait cmd /c "%SOURCE%_install.cmd"
IF NOT %ERRORLEVEL%==0 ( ECHO Installation failed: %ERRORLEVEL% ) ELSE ( ECHO Installation completed successfully. )

ECHO.
PAUSE