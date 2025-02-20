#!/usr/bin/env bash

PROGNAME="$(basename "$0")"
SCRIPT_DIR="$(dirname "$0")"
LUAJIT_SOURCE_DIR=$SCRIPT_DIR/luajit-2.1/src

usage () {
  echo "usage: $PROGNAME [--debug]"
}

cc_debug=

while [[ -n "$1" ]]; do
  case "$1" in
    --debug) cc_debug=" -g" ;;
    -h | --help) usage; exit ;;
    *) usage >&2; exit 1 ;;
  esac
  shift
done

if [ -z "$MACOSX_DEPLOYMENT_TARGET" ]; then
  export MACOSX_DEPLOYMENT_TARGET="11.0"
  echo "Warning: MACOSX_DEPLOYMENT_TARGET is by DEFAULT setting to 11.0."
fi

# Apple Silicon - Arm64
ISDKF="-arch arm64"
make -C $LUAJIT_SOURCE_DIR clean
make -C $LUAJIT_SOURCE_DIR HOST_CC=clang TARGET_FLAGS="$ISDKF" CCDEBUG="$cc_debug" XCFLAGS="$LUAJIT_XCFLAGS"
