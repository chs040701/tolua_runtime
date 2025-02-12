@rem Script to build tolua for Android arm64.
@rem Copyright (C) 2025 Rython Fu.

@setlocal enabledelayedexpansion

@set ANDROID_ABI=arm64-v8a
@set ANDROID_NATIVE_API_LEVEL=21
@set CONFIG=Release
@set BUILD_DIR=.\Build\android\%ANDROID_ABI%
@set INSTALL_DIR=.\Plugins\Android\%ANDROID_ABI%

@cmake ^
  -B "%BUILD_DIR%" ^
  -G Ninja ^
  -DCMAKE_TOOLCHAIN_FILE="%ANDROID_NDK_HOME%\build\cmake\android.toolchain.cmake" ^
  -DCMAKE_BUILD_TYPE=%CONFIG% ^
  -DANDROID_ABI="%ANDROID_ABI%" ^
  -DANDROID_PLATFORM="%ANDROID_NATIVE_API_LEVEL%"

@cmake ^
  --build "%BUILD_DIR%" ^
  --config %CONFIG%

@if not exist "%INSTALL_DIR%" (
  @md "%INSTALL_DIR%"
)
copy /y "%BUILD_DIR%\libtolua.so" "%INSTALL_DIR%"
