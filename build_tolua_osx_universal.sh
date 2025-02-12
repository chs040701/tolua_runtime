#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
ARCH=universal
CONFIG=Release
BUILD_DIR="${SCRIPT_DIR}/build/osx/${ARCH}"
INSTALL_DIR="${SCRIPT_DIR}/Plugins/macOS/${ARCH}"

cmake \
  -B "${BUILD_DIR}" \
  -G Xcode \
  -DCMAKE_TOOLCHAIN_FILE="./cmake/ios.toolchain.cmake" \
  -DPLATFORM=MAC_UNIVERSAL \
  -DDEPLOYMENT_TARGET=11.0

cmake \
  --build "${BUILD_DIR}" \
  --config ${CONFIG}

mkdir -p "$INSTALL_DIR"
cp -Rf "${BUILD_DIR}/${CONFIG}/tolua.bundle" "${INSTALL_DIR}"
