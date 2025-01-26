ToLua Runtime
=============
Maintained ToLua runtime for Unity games using ToLua.

Motivation
----------
- Mainly to update outdated libraries.
- Upgrade build script or toolchains for each platforms.

Build
-----
pc: build_win32.sh build_win64.h  (mingw + luajit2.0.4) <br>
android: build_arm.sh build_x86.sh (mingw + luajit2.0.4) <br>
mac: build_osx.sh (xcode + luac5.1.5 for luajit can't run on unity5) <br>
ios: build_ios.sh (xcode + luajit2.1 beta) <br>

NDK 版本:android-ndk-r10e 默认安装到 D:/android-ndk-r10e<br>
https://dl.google.com/android/repository/android-ndk-r10e-windows-x86_64.zip<br>
Msys2配置说明<br>
https://github.com/topameng/tolua_runtime/wiki<br>
配置好的Msys2下载<br>
https://pan.baidu.com/s/1c2JzvDQ<br>

Libraries
---------
|                     | Version  | Notes                         |
| ------------------- | -------- | ----------------------------- |
| [lua-cjson][1]      | 2.1.0.14 | Moved from [mpx/lua-cjson][2] |
| [luasocket][3]      | 3.1.0    |                               |
| [protoc-gen-lua][4] |          |                               |
| [struct][5]         |          |                               |
| [lpeg][6]           |          |                               |

[1]: https://github.com/openresty/lua-cjson/tree/91ca29db9a4a4fd0eedaebcd5d5f3ba2ace5ae63
[2]: https://github.com/mpx/lua-cjson
[3]: https://github.com/lunarmodules/luasocket/tree/v3.1.0
[4]: https://github.com/topameng/protoc-gen-lua
[5]: http://www.inf.puc-rio.br/~roberto/struct/
[6]: http://www.inf.puc-rio.br/~roberto/lpeg/lpeg.html
