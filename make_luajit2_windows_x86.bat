@rem Script to build LuaJIT with MSVC using provided `msvcbuild.bat`.
@rem Copyright (C) 2025 Rython Fu.
@rem
@rem Use the following options, if needed. The default is a static release build.
@rem
@rem   debug             whether emit debug symbols

@setlocal enabledelayedexpansion

@if "%1" neq "debug" goto :NODEBUG
@set MSVCBUILD_ARGS=debug static
@shift
:NODEBUG
@set MSVCBUILD_ARGS=static

@rem Store Visual Studio installation path in `VS_PATH`.
call find_latest_vs.bat > vs_path.txt
@if errorlevel 1 goto :BAD
for /f "delims=" %%i in (vs_path.txt) do set VS_PATH=%%i
@echo Visual Studio: %VS_PATH%

@set LUAJIT_SOURCE_DIR=%~dp0\luajit-2.1\src
call "%VS_PATH%\VC\Auxiliary\Build\vcvarsall.bat" x86 && (
    cd /d "%LUAJIT_SOURCE_DIR%"
    call msvcbuild.bat %MSVCBUILD_ARGS%
)
goto :END

:BAD
@echo.
@echo *************************************************
@echo *** FAILED -- Please check the error messages ***
@echo *************************************************
:END
del %~dp0\vs_path.txt
