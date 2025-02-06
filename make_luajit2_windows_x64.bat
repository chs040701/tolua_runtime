@rem Script to build LuaJIT with MSVC using provided `msvcbuild.bat`.
@rem Copyright (C) 2025 Rython Fu.
@rem
@rem Use the following options, if needed. The default is a static release build.
@rem
@rem   debug    whether emit debug symbols

@echo off
setlocal enabledelayedexpansion

@if "%1" neq "debug" goto :NODEBUG
set MSVCBUILD_ARGS=debug static
:NODEBUG
set MSVCBUILD_ARGS=static

set VSWHERE_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe
if not exist "%VSWHERE_PATH%" (
    echo Error: vswhere.exe not found. Ensure Visual Studio 2017+ is installed.
    exit /b 1
)

for /f "usebackq tokens=*" %%i in (`"%VSWHERE_PATH%" -latest -property installationPath`) do (
    set VS_PATH=%%i
)
if not defined VS_PATH (
    echo Error: Visual Studio installation not found.
    exit /b 1
)

set LUAJIT_SOURCE_DIR=%~dp0\luajit-2.1\src
call "%VS_PATH%\VC\Auxiliary\Build\vcvarsall.bat" x64 && (
    cd /d "%LUAJIT_SOURCE_DIR%"
    call msvcbuild.bat %MSVCBUILD_ARGS%
)
