#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
ARCH=x86_64
CONFIG=Release
BUILD_DIR="${SCRIPT_DIR}/Build/osx/${ARCH}"
INSTALL_DIR="${SCRIPT_DIR}/Plugins/macOS/${ARCH}"

cmake \
  -B "$BUILD_DIR" \
  -G Xcode \
  -DCMAKE_TOOLCHAIN_FILE="${SCRIPT_DIR}/cmake/ios.toolchain.cmake" \
  -DPLATFORM=MAC \
  -DDEPLOYMENT_TARGET=11.0

cmake \
  --build "$BUILD_DIR" \
  --config $CONFIG

mkdir -p "$INSTALL_DIR"
cp -Rf "${BUILD_DIR}/${CONFIG}/tolua.bundle" "${INSTALL_DIR}"
