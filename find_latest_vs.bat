@rem Script to find latest installed visual studio using vswhere.
@rem Copyright (C) 2025 Rython Fu.

@setlocal enabledelayedexpansion

@set VSWHERE_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe
@if not exist "%VSWHERE_PATH%" goto :NOVSWHERE

@for /f "usebackq tokens=*" %%i in (`"%VSWHERE_PATH%" -latest -property installationPath`) do (
    @set VS_PATH=%%i
    goto :FOUND
)

:NOVSWHERE
@echo Error: vswhere.exe not found. Ensure Visual Studio 2017+ is installed.
@goto :BAD

:NOVS
@echo Error: Visual Studio installation not found.
@goto :BAD

:FOUND
@echo %VS_PATH%
@goto :END

:BAD
exit /b 1
:END
