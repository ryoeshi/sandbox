@echo off
@setlocal enabledelayedexpansion

@set CONVERT="C:\Program Files\ImageMagick-6.5.3-Q16\convert.exe"
@set ROOTDIR=%~1%
@set ROOTDIR="%ROOTDIR%"

echo åãçáäJén - %ROOTDIR%

%~d1%
rem echo !CD!
rem pause
cd %ROOTDIR%
rem echo current: !CD!
rem pause
for /d %%i in (%ROOTDIR%\*) do (
	set DNAME=%%~ni
	set TARGET=%%i
	set TARGET="!TARGET!"
	rem echo %%i
	pushd !TARGET!
	rem echo current: !CD!

	set FNAMES=00.jpg 01.jpg 
	%CONVERT% -append !FNAMES!..\!DNAME!.jpg
	rem echo %CONVERT% -append !FNAMES!..\!DNAME!.jpg
	rem pause
	echo done. [!DNAME!.jpg]
	
	popd
	if exist "!DNAME!.jpg" rmdir /s /q !TARGET!
)
