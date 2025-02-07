#!/usr/bin/env bash

export ANDROID_ABI=arm64-v8a
export ANDROID_NATIVE_API_LEVEL=21

cmake \
  -B "./build/android/${ANDROID_ABI}" \
  -G Ninja \
  -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake" \
  -DANDROID_ABI=${ANDROID_ABI} \
  -DANDROID_PLATFORM=${ANDROID_NATIVE_API_LEVEL}

cmake \
  --build "./build/android/${ANDROID_ABI}" \
  --config Release
