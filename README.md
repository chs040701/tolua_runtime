ToLua Runtime
=============
Maintained ToLua runtime for Unity games using ToLua.

Motivation
----------
- Mainly to update outdated libraries.
- Upgrade build script or toolchains for each platforms.

Build
-----
|                    | Platforms    | Commands           | Notes               |
| :----------------- | ------------ | ------------------ | ------------------- |
|                    | Windows(x86) | `build_win32.sh`   | mingw + luajit2.0.4 |
|                    | Windows(x64) | `build_win64.h`    | mingw + luajit2.0.4 |
|                    | Android(arm) | `build_arm.sh`     | mingw + luajit2.0.4 |
|                    | Android(x86) | `build_x86.sh`     | mingw + luajit2.0.4 |
| :heavy_check_mark: | macOS        | `build_osxjit.sh`  | Xcode + LuaJIT v2.1 |
| :heavy_check_mark: | iOS          | `build_ios.sh`     | Xcode + LuaJIT v2.1 |
|                    | Linux        | `build_ubuntu.sh`? |                     |

NDK 版本:android-ndk-r10e 默认安装到 D:/android-ndk-r10e<br>
https://dl.google.com/android/repository/android-ndk-r10e-windows-x86_64.zip<br>
Msys2配置说明<br>
https://github.com/topameng/tolua_runtime/wiki<br>
配置好的Msys2下载<br>
https://pan.baidu.com/s/1c2JzvDQ<br>

Libraries
---------
LuaJIT is updated to (current) latest v2.1 branch (commit at 2025-01-13 16:22:22)

|                     | Version   | Notes                         |
| ------------------- | --------- | ----------------------------- |
| [lua-cjson][1]      | v2.1.0.14 | Moved from [mpx/lua-cjson][2] |
| [luasocket][3]      | v3.1.0    | original v3.0-rc1             |
| [protoc-gen-lua][4] |           |                               |
| [struct][5]         | v1.8      | original v1.4                 |
| [lpeg][6]           | v1.1.0    | original v0.10                |

[1]: https://github.com/openresty/lua-cjson/tree/91ca29db9a4a4fd0eedaebcd5d5f3ba2ace5ae63
[2]: https://github.com/mpx/lua-cjson
[3]: https://github.com/lunarmodules/luasocket/tree/v3.1.0
[4]: https://github.com/topameng/protoc-gen-lua
[5]: http://www.inf.puc-rio.br/~roberto/struct/
[6]: http://www.inf.puc-rio.br/~roberto/lpeg/lpeg.html
