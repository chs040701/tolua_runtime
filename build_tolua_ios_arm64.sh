#!/usr/bin/env bash

export CONFIG=Release

cmake \
  -B "./build/ios/arm64" \
  -G Xcode \
  -DCMAKE_TOOLCHAIN_FILE="./cmake/ios.toolchain.cmake" \
  -DCMAKE_BUILD_TYPE=${CONFIG} \
  -DPLATFORM=OS64 \
  -DDEPLOYMENT_TARGET=13.0

cmake \
  --build "./build/ios/arm64" \
  --config ${CONFIG}
