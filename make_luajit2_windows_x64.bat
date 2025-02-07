@rem Script to build LuaJIT with MSVC using provided `msvcbuild.bat`.
@rem Copyright (C) 2025 Rython Fu.
@rem
@rem Use the following options, if needed. The default is a static release build.
@rem
@rem   debug             whether emit debug symbols
@rem   <install_path>    the path to install the built binaries

@setlocal enabledelayedexpansion

@if "%1" neq "debug" goto :NODEBUG
@set MSVCBUILD_ARGS=debug static
@shift
:NODEBUG
@set MSVCBUILD_ARGS=static

call find_latest_vs.bat
@if errorlevel 1 goto :BAD

@set VS_PATH=%VS_PATH%
@set LUAJIT_SOURCE_DIR=%~dp0\luajit-2.1\src

call "%VS_PATH%\VC\Auxiliary\Build\vcvarsall.bat" x64 && (
    cd /d "%LUAJIT_SOURCE_DIR%"
    call msvcbuild.bat %MSVCBUILD_ARGS%
)

:BAD
@echo.
@echo *************************************************
@echo *** FAILED -- Please check the error messages ***
@echo *************************************************
:END