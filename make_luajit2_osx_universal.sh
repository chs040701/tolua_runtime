#!/usr/bin/env bash

# NOTE: this script is used by CMake to build a universal macOS binary.
# It in the end will puts the result into the current directory, named *libluajit.a*.
#
# If you want to execute it, be sure to run it from the luajit source directory.
# 
# Options: "-g" for generating debug information

if [ -z "$MACOSX_DEPLOYMENT_TARGET" ]; then
  export MACOSX_DEPLOYMENT_TARGET="11.0"
  echo "Warning: MACOSX_DEPLOYMENT_TARGET is by DEFAULT setting to 11.0."
fi

SCRIPT_DIR=$(dirname "$0")
LUAJIT_SOURCE_DIR=$SCRIPT_DIR/luajit-2.1/src

TMP_DIR=$(mktemp -d)

# Apple Silicon - Arm64
ISDKF="-arch arm64"
make -C $LUAJIT_SOURCE_DIR clean
make -C $LUAJIT_SOURCE_DIR HOST_CC=clang TARGET_FLAGS="$ISDKF" CCDEBUG=" $1"
cp -i $LUAJIT_SOURCE_DIR/libluajit.a $TMP_DIR/libluajit-arm64.a

# Intel - x86_64
ISDKF="-arch x86_64 -masm=intel"
make -C $LUAJIT_SOURCE_DIR clean
make -C $LUAJIT_SOURCE_DIR HOST_CC=clang TARGET_FLAGS="$ISDKF" CCDEBUG=" $1"
cp -i $LUAJIT_SOURCE_DIR/libluajit.a $TMP_DIR/libluajit-x86_64.a

# Create universal binary
lipo -create -output $TMP_DIR/libluajit.a $TMP_DIR/libluajit-*.a
cp -f $TMP_DIR/libluajit.a $LUAJIT_SOURCE_DIR/libluajit.a
