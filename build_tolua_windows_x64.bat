@rem Script to build tolua for Android arm64.
@rem Copyright (C) 2025 Rython Fu.

@setlocal enabledelayedexpansion

@set GENERATOR="Visual Studio 17 2022"
@set ARCH=x86_64
@set CMAKE_ARCH=x64

@cmake ^
  --fresh ^
  -G %GENERATOR% ^
  -A %CMAKE_ARCH% ^
  -B ".\build\windows\%ARCH%"

@cmake ^
  --build ".\build\windows\%ARCH%" ^
  --config Release

copy /y ".\build\windows\%ARCH%\Release\tolua.dll" ".\Plugins\Windows\%ARCH%"
