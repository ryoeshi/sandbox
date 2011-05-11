@echo off
@setlocal enabledelayedexpansion

@rem 実行されるのは[wwwc]\[ユーザ名]ディレクトリの下なので、無条件でtoolディレクトリに移動
cd ..\tool

@rem 環境変数から各種情報を取得
IF "%HTTP_PROXY%"=="" (
  set PROXY_OPTION=
) ELSE (
  set PROXY_OPTION= -e http_proxy=%HTTP_PROXY% --no-cache
)
rem set WGETDIR=C:\kurosawa\bin\tool\wget
set WGET=D:\bin\tool\wget-complete-stable\wget.exe

@rem 更新情報ファイル
set DATFILE=Item.dat
@rem 更新ページ記録ファイル名
set SAVENAME=%date:/=_%_%time::=_%.html
set SAVENAME=!SAVENAME: =0!
@rem ログファイル名
set LOGNAME="%CD%\updatebackup.log"

rem echo 検索対象ファイル [%DATFILE%]
rem echo ログファイル [%LOGNAME%]

@rem 一応、実行日を記録
echo --- [backup start] %date% %time% CD[%CD%] --- >> updatebackup.log

@rem 実行したディレクトリのサブディレクトリを全て処理する
cd ..
FOR /R %%i IN (.) DO ( 
	pushd %%i
	IF EXIST %DATFILE% (
rem		echo %DATFILE% found. - %%~fi
		@rem 更新情報ファイルを開いて、名称、チェック対象URL、更新情報を取得
		set index=0
		FOR /F "usebackq tokens=1,2,5 delims=	" %%j IN (`type %DATFILE%`) DO (
			set index=00!index!
rem			echo %%j - 更新状態: %%l
			IF %%l==1 (
				@rem 更新があればその時点のページ情報を保存
				echo [更新あり] 取得対象URL - %%k - 保存先 : %SAVENAME%
				@rem wgetが吐いたエラーもログに記録
rem				%WGET% -a "%WGETDIR%\wget.log" -e http_proxy=%PROXY% -O "%SAVENAME%" -nv "%%k"
				echo wget !PROXY_OPTION! -O "!index:~-3!-%SAVENAME%" -nv "%%k" 1>>%LOGNAME% 2>&1
				%WGET% !PROXY_OPTION! -O "!index:~-3!-%SAVENAME%" -nv "%%k" 1>>%LOGNAME% 2>&1
				echo - 取得完了 -
			) ELSE IF "%1%"=="1" (
				echo wget !PROXY_OPTION! -O "!index:~-3!-%SAVENAME%" -nv "%%k" 1>>%LOGNAME% 2>&1
				%WGET% !PROXY_OPTION! -O "!index:~-3!-%SAVENAME%" -nv "%%k" 1>>%LOGNAME% 2>&1
			)
			set /a index=!index! + 1
		)
rem		echo -----
	)
	popd
)

cd tool
echo --- [backup done] --- >> updatebackup.log

echo done.
