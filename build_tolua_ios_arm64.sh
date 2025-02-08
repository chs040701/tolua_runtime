#!/usr/bin/env bash

cmake \
    -B "./build/ios/arm64" \
    -G Xcode \
    -DCMAKE_TOOLCHAIN_FILE="./cmake/ios.toolchain.cmake" \
    -DPLATFORM=OS64 \
    -DDEPLOYMENT_TARGET=13.0

cmake \
    --build "./build/ios/arm64" \
    --config Release
