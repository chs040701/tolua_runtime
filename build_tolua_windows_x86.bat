@rem Script to build tolua for Android arm64.
@rem Copyright (C) 2025 Rython Fu.

@setlocal enabledelayedexpansion

@set GENERATOR="Visual Studio 17 2022"
@set ARCH=x86
@set CMAKE_ARCH=Win32
@set CONFIG=Release

@cmake ^
  --fresh ^
  -G %GENERATOR% ^
  -A %CMAKE_ARCH% ^
  -B ".\build\windows\%ARCH%" ^
  -DCMAKE_BUILD_TYPE=%CONFIG%

@cmake ^
  --build ".\build\windows\%ARCH%" ^
  --config %CONFIG%

copy /y ".\build\windows\%ARCH%\%CONFIG%\tolua.dll" ".\Plugins\Windows\%ARCH%"
