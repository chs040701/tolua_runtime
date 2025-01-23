#!/usr/bin/env bash

cd macnojit/
xcodebuild clean
xcodebuild -configuration=Release
cp -R build/Release/tolua.bundle ../Plugins/
