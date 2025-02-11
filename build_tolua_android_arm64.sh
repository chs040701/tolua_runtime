#!/usr/bin/env bash

export ANDROID_ABI=arm64-v8a
export ANDROID_NATIVE_API_LEVEL=21
export CONFIG=Release
export BUILD_DIR="./build/android/${ANDROID_ABI}"
export INSTALL_DIR="./Plugins/Android/${ANDROID_ABI}"

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
