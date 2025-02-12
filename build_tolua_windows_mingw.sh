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
INSTALL_DIR="${SCRIPT_DIR}/Plugins/Windows/${ARCH}"
CONFIG=Release

cmake \
  -B "${BUILD_DIR}" \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=$CONFIG

cmake \
  --build "${BUILD_DIR}" \
  --config $CONFIG

mkdir -p "$INSTALL_DIR"
cp -f "${BUILD_DIR}/libtolua.dll" "${INSTALL_DIR}/tolua.dll"
