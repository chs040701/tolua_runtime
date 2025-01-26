#!/usr/bin/env bash

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LUAJIT_D=$CWD/luajit-2.1/src
DEST_D=$CWD/macjit

export MACOSX_DEPLOYMENT_TARGET=10.8

rm $DEST_D/*.a
cd $LUAJIT_D

make clean
ISDKF="-arch arm64"
make -j4 HOST_CC=clang TARGET_FLAGS="$ISDKF"
mv $LUAJIT_D/libluajit.a $DEST_D/libluajit-arm64.a

make clean
ISDKF="-arch x86_64 -masm=intel"
make -j4 HOST_CC=clang TARGET_FLAGS="$ISDKF"
mv $LUAJIT_D/libluajit.a $DEST_D/libluajit-x86_64.a

cd $DEST_D
lipo -create $DEST_D/libluajit-*.a -output $DEST_D/libluajit.a 
strip -S $DEST_D/libluajit.a

xcodebuild clean
xcodebuild -configuration=Release
