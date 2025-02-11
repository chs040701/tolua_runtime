#!/usr/bin/env bash

cmake \
  -B "./build/osx/universal" \
  -G Xcode \
  -DCMAKE_TOOLCHAIN_FILE="./cmake/ios.toolchain.cmake" \
  -DPLATFORM=MAC_UNIVERSAL \
  -DDEPLOYMENT_TARGET=11.0

cmake \
  --build "./build/osx/universal" \
  --config Release
