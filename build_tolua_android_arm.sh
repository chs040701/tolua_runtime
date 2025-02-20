#!/usr/bin/env bash

ANDROID_ABI=armeabi-v7a
ANDROID_NATIVE_API_LEVEL=21
CONFIG=Release
BUILD_DIR="./Build/android/${ANDROID_ABI}"
INSTALL_DIR="./Plugins/Android/${ANDROID_ABI}"

cmake \
  -B "${BUILD_DIR}" \
  -G Ninja \
  -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake" \
  -DCMAKE_BUILD_TYPE=${CONFIG} \
  -DANDROID_ABI=${ANDROID_ABI} \
  -DANDROID_PLATFORM=${ANDROID_NATIVE_API_LEVEL}

cmake \
  --build "${BUILD_DIR}" \
  --config ${CONFIG}

mkdir -p "$INSTALL_DIR"
cp -f "${BUILD_DIR}/libtolua.so" "${INSTALL_DIR}"
