@rem Script to build LuaJIT with MSVC using provided `msvcbuild.bat`.
@rem Copyright (C) 2025 Rython Fu.
@rem
@rem Acceptable architectures for the first argument: `x64`, `x86`.
@rem 
@rem Use the following options, if needed. The default is a static release build.
@rem
@rem   nogc64   disable LJ_GC64 mode for x64
@rem   debug    whether emit debug symbols

@setlocal enabledelayedexpansion

@set ARCH=%~1
@shift

@set MSVCBUILD_ARGS=%* static

@rem Store Visual Studio installation path in `VS_PATH`.
@set TMPFILE_VS_PATH=%TMP%\vs~%RANDOM%.txt
@call find_latest_vs.bat > %TMPFILE_VS_PATH%
@if errorlevel 1 goto :BAD
@for /f "delims=" %%i in (%TMPFILE_VS_PATH%) do @set VS_PATH=%%i

@set LUAJIT_SOURCE_DIR=%~dp0\luajit-2.1\src
call "%VS_PATH%\VC\Auxiliary\Build\vcvarsall.bat" %ARCH% && (
    cd /d "%LUAJIT_SOURCE_DIR%"
    call msvcbuild.bat %MSVCBUILD_ARGS%
)
@goto :END

:BAD
@echo.
@echo *************************************************
@echo *** FAILED -- Please check the error messages ***
@echo *************************************************

:END
@del %TMPFILE_VS_PATH%
