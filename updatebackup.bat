@echo off
@setlocal enabledelayedexpansion

@rem ���s�����̂�[wwwc]\[���[�U��]�f�B���N�g���̉��Ȃ̂ŁA��������tool�f�B���N�g���Ɉړ�
cd ..\tool

@rem ���ϐ�����e������擾
IF "%HTTP_PROXY%"=="" (
  set PROXY_OPTION=
) ELSE (
  set PROXY_OPTION= -e http_proxy=%HTTP_PROXY% --no-cache
)
rem set WGETDIR=C:\kurosawa\bin\tool\wget
set WGET=D:\bin\tool\wget-complete-stable\wget.exe

@rem �X�V���t�@�C��
set DATFILE=Item.dat
@rem �X�V�y�[�W�L�^�t�@�C����
set SAVENAME=%date:/=_%_%time::=_%.html
set SAVENAME=!SAVENAME: =0!
@rem ���O�t�@�C����
set LOGNAME="%CD%\updatebackup.log"

rem echo �����Ώۃt�@�C�� [%DATFILE%]
rem echo ���O�t�@�C�� [%LOGNAME%]

@rem �ꉞ�A���s�����L�^
echo --- [backup start] %date% %time% CD[%CD%] --- >> updatebackup.log

@rem ���s�����f�B���N�g���̃T�u�f�B���N�g����S�ď�������
cd ..
FOR /R %%i IN (.) DO ( 
	pushd %%i
	IF EXIST %DATFILE% (
rem		echo %DATFILE% found. - %%~fi
		@rem �X�V���t�@�C�����J���āA���́A�`�F�b�N�Ώ�URL�A�X�V�����擾
		set index=0
		FOR /F "usebackq tokens=1,2,5 delims=	" %%j IN (`type %DATFILE%`) DO (
			set index=00!index!
rem			echo %%j - �X�V���: %%l
			IF %%l==1 (
				@rem �X�V������΂��̎��_�̃y�[�W����ۑ�
				echo [�X�V����] �擾�Ώ�URL - %%k - �ۑ��� : %SAVENAME%
				@rem wget���f�����G���[�����O�ɋL�^
rem				%WGET% -a "%WGETDIR%\wget.log" -e http_proxy=%PROXY% -O "%SAVENAME%" -nv "%%k"
				echo wget !PROXY_OPTION! -O "!index:~-3!-%SAVENAME%" -nv "%%k" 1>>%LOGNAME% 2>&1
				%WGET% !PROXY_OPTION! -O "!index:~-3!-%SAVENAME%" -nv "%%k" 1>>%LOGNAME% 2>&1
				echo - �擾���� -
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
