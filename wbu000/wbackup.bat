@echo off
rem WWWC item backup.
if "%1" == "" goto END
set dn=%2
if "%dn%" == "" set dn=backup

if "%OS%" == "Windows_NT" goto WINNT
if exist %1\..\%dn%2\nul deltree /Y "%1\..\%dn%2"
goto TREECOPY

:WINNT
if exist %1\..\%dn%2\nul rmdir /S /Q "%1\..\%dn%2"

:TREECOPY
ren "%1\..\%dn%1" "%dn%2"
xcopy /E /H "%1" "%1\..\%dn%1\"

:END
