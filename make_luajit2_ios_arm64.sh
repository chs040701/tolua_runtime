#!/usr/bin/env bash

PROGNAME="$(basename "$0")"
SCRIPT_DIR="$(dirname "$0")"
LUAJIT_SOURCE_DIR=$SCRIPT_DIR/luajit-2.1/src

usage () {
  echo "usage: $PROGNAME [--debug] [--ios-deployment-target version]"
}

cc_debug=
deployment_target=13.0

while [[ -n "$1" ]]; do
  case "$1" in
    --debug) cc_debug=" -g" ;;
    --ios-deployment-target) shift; deployment_target="$1" ;;
    -h | --help) usage; exit ;;
    *) usage >&2; exit 1 ;;
  esac
  shift
done

ISDKP=$(xcrun --sdk iphoneos --show-sdk-path)
ICC=$(xcrun --sdk iphoneos --find clang)

# Arm64
ISDKF="-arch arm64 -isysroot $ISDKP -miphoneos-version-min=$deployment_target"
make -C $LUAJIT_SOURCE_DIR \
  TARGET_SYS=iOS \
  clean
make -C $LUAJIT_SOURCE_DIR \
  DEFAULT_CC=clang \
  CCDEBUG="$cc_debug" \
  XCFLAGS="$LUAJIT_XCFLAGS" \
  CROSS="$(dirname $ICC)/" \
  TARGET_FLAGS="$ISDKF" \
  TARGET_SYS=iOS \
  BUILDMODE=static
