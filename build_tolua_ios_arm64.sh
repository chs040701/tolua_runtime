#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
ARCH=arm64
CONFIG=Release
BUILD_DIR="${SCRIPT_DIR}/Build/ios/${ARCH}"
INSTALL_DIR="./Plugins/iOS/${ARCH}"

cmake \
  -B "$BUILD_DIR" \
  -G Xcode \
  -DCMAKE_TOOLCHAIN_FILE="${SCRIPT_DIR}/cmake/ios.toolchain.cmake" \
  -DPLATFORM=OS64 \
  -DDEPLOYMENT_TARGET=13.0

cmake \
  --build "$BUILD_DIR" \
  --config $CONFIG

mkdir -p "$INSTALL_DIR"
cp -f "${BUILD_DIR}/${CONFIG}-iphoneos/libtolua.a" "$INSTALL_DIR"
