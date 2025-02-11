#!/usr/bin/env bash

if [ "$MSYSTEM" = "MINGW32" ]; then
  ARCH=x86
elif [ "$MSYSTEM" = "MINGW64" ]; then
  ARCH=x86_64
else
  echo "Unknown platform: $MSYSTEM"
  exit 1
fi

SCRIPT_DIR="$(dirname "$0")"
BUILD_DIR="${SCRIPT_DIR}/build/windows/${ARCH}-mingw"

cmake \
  -B "${BUILD_DIR}" \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release

cmake \
  --build "${BUILD_DIR}" \
  --config Release

cp -f "${BUILD_DIR}/libtolua.dll" "./Plugins/Windows/${ARCH}/tolua.dll"
