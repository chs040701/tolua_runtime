#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LIPO="xcrun -sdk iphoneos lipo"
STRIP="xcrun -sdk iphoneos strip"

SRCDIR=$DIR/luajit-2.1/src
DESTDIR=$DIR/iOS

rm "$DESTDIR"/*.a

# iOS/ARM64
ISDKP=$(xcrun --sdk iphoneos --show-sdk-path)
ICC=$(xcrun --sdk iphoneos --find clang)
ISDKF="-arch arm64 -isysroot $ISDKP -miphoneos-version-min=8.0 -fembed-bitcode"
make -C $SRCDIR DEFAULT_CC=clang CROSS="$(dirname $ICC)/" TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS BUILDMODE=static clean
make -C $SRCDIR DEFAULT_CC=clang CROSS="$(dirname $ICC)/" TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS BUILDMODE=static
mv "$SRCDIR"/libluajit.a "$DESTDIR"/libluajit.a

cd "$DESTDIR"

xcodebuild clean
xcodebuild -configuration=Release
cp -f ./build/Release-iphoneos/libtolua.a ../Plugins/iOS/

