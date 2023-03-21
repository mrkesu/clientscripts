@ECHO OFF
SET SOURCE=%~dp0

ECHO Stopper Quick Assist dersom det kjører
Taskkill /IM quickassist.exe /F

ECHO Installerer Quick Assist...
CD %SOURCE%
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SOURCE%DeployQA.ps1"
IF NOT %ERRORLEVEL%==0 EXIT %ERRORLEVEL%