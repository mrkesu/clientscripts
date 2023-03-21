@ECHO OFF
SET SOURCE=%~dp0

ECHO Uninstalling...
CD %SOURCE%
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SOURCE%UndeployQA.ps1"
IF NOT %ERRORLEVEL%==0 EXIT %ERRORLEVEL%