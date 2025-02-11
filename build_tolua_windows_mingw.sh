#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"

if [ "$MSYSTEM" = "MINGW32" ]; then
    BUILD_DIR="${SCRIPT_DIR}/build/windows/x86"
elif [ "$MSYSTEM" = "MINGW64" ]; then
    BUILD_DIR="${SCRIPT_DIR}/build/windows/x86_64"
else
    echo "Unknown platform: $MSYSTEM"
    exit 1
fi

cmake \
    --fresh \
    -B "${BUILD_DIR}" \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release

cmake \
    --build "${BUILD_DIR}" \
    --config Release
