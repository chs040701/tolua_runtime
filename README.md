ToLua Runtime
=============
Maintained ToLua runtime for Unity games using ToLua.


Motivation
----------
- Mainly to update outdated libraries.
- Upgrade build script or toolchains for each platforms.


Build
-----
CMake 3.14+ is required to build `tolua` and cross-compiling.

|                   | Windows (MSYS2)    | Windows                   | macOS              | Linux              |
| ----------------- | ------------------ | ------------------------- | ------------------ | ------------------ |
| Windows (x86)     | :heavy_check_mark: | :heavy_check_mark: (msvc) | :x:                | :x:                |
| Windows (x64)     | :heavy_check_mark: | :heavy_check_mark: (msvc) | :x:                | :x:                |
| Windows (arm64)   | :x:                | :heavy_check_mark: (msvc) | :x:                | :x:                |
| Android (arm)     | :heavy_check_mark: | :x:                       | :x:                | :x:                |
| Android (arm64)   | :heavy_check_mark: | :heavy_check_mark: (gcc)  | :heavy_check_mark: | :heavy_check_mark: |
| macOS (universal) | :x:                | :x:                       | :heavy_check_mark: | :x:                |
| macOS (arm64)     | :x:                | :x:                       | :heavy_check_mark: | :x:                |
| macOS (x64)       | :x:                | :x:                       | :heavy_check_mark: | :x:                |
| iOS (arm64)       | :x:                | :x:                       | :heavy_check_mark: | :x:                |

> NOTE: Every predefiend build script would install the target library to *Plugins*
> folder, which could be placed on any subfolder in *Assets*, according to the 
> [disccusion](https://discussions.unity.com/t/plugins-folder-inside-a-unity-package-does-it-have-to-be-on-the-root-folder-or-not/934638/2)
> for newer version of Unity.

### Windows
When targeting Windows, MINGW is preferred over MSVC (luajit options not supported).

#### MSVC (WIP)
Visual Studio 2017+ should work (Tested for Visual Studio 2022)

```bat
> .\build_tolua_windows_x86.bat
> .\build_tolua_windows_x64.bat
> .\build_tolua_windows_arm64.bat
```

> IMPORTANT: Symbols from LuaJIT is stuck for exporting to shared library now.
> Refer to [#1341](https://github.com/LuaJIT/LuaJIT/issues/1341) for any progress.

#### MSYS2
Install MSYS2 and prepare MSYS2 environment and toolchains.

```bash
$ pacman -S git
$ pacman -S make
$ # For x86
$ pacman -S mingw-w64-i686-cmake
$ pacman -S mingw-w64-i686-gcc
$ # For x86_64
$ pacman -S mingw-w64-x86_64-cmake
$ pacman -S mingw-w64-x86_64-gcc
```

To build, symply run:
```bash
$ ./build_tolua_windows_mingw.sh
```

### Android
To build for Android, you need to install the Android NDK and Ninja.

The default ANDROID_NATIVE_API_LEVEL is set to 21.


Set environment variable `ANDROID_NDK_HOME` to the path of the NDK,
e.g. `export ANDROID_NDK_HOME=/path/to/android-ndk-r27c` on UNIX-like systems, or
pass `-DANDROID_NDK=/path/to/android-ndk-r27c` to CMake command.

#### Cross-compiling on Windows
Using [Scoop](https://scoop.sh/) or other package managers to install `gcc`.
```bat
> set ANDROID_NDK_HOME=C:\path\to\android-ndk-r27c && .\build_tolua_android_arm64.bat
```

For MinGW, it is the same as build on UNIX-like system.
```bash
$ ANDROID_NDK_HOME=C:/path/to/android-ndk-r27c ./build_tolua_android_arm64.sh
$ ANDROID_NDK_HOME=C:/path/to/android-ndk-r27c ./build_tolua_android_arm.sh
```

#### Cross-compiling on UNIX-like
```bash
$ ANDROID_NDK_HOME=/path/to/android-ndk-r27c ./build_tolua_android_arm64.sh
$ ANDROID_NDK_HOME=/path/to/android-ndk-r27c ./build_tolua_android_arm.sh
```

### macOS
Xcode is needed for macOS.
The default DEPLOYMENT_TARGET is set to 11.0.

```bash
$ ./build_tolua_osx_universal.sh
$ ./build_tolua_osx_arm64.sh
$ ./build_tolua_osx_x64.sh
```

### iOS
Xcode is needed to build for iOS.
The default DEPLOYMENT_TARGET is set to 13.0.

```bash
$ ./build_tolua_ios_arm64.sh
```


Libraries
---------
LuaJIT is updated to (current) latest v2.1 branch (commit at 2025-01-13 16:22:22),
but currently using a [forked repository](https://github.com/alex4814/luajit).

|                              | Version   | Notes                         |
| ---------------------------- | --------- | ----------------------------- |
| [openresty/lua-cjson][1]     | v2.1.0.14 | Moved from [mpx/lua-cjson][2] |
| [lunarmodules/luasocket][3]  | v3.1.0    | original v3.0-rc1             |
| [topameng/protoc-gen-lua][4] |           |                               |
| [struct][5]                  | v1.8      | original v1.4                 |
| [alex4814/lpeg-luajit][6]    | v1.1.0    | original v0.10                |

[1]: https://github.com/openresty/lua-cjson/tree/2.1.0.14
[2]: https://github.com/mpx/lua-cjson
[3]: https://github.com/lunarmodules/luasocket/tree/v3.1.0
[4]: https://github.com/topameng/protoc-gen-lua
[5]: http://www.inf.puc-rio.br/~roberto/struct/
[6]: https://github.com/alex4814/lpeg-luajit
