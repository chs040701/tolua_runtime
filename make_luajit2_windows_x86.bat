@rem Script to build LuaJIT with MSVC using provided `msvcbuild.bat`.
@rem Copyright (C) 2025 Rython Fu.
@rem
@rem Use the following options, if needed. The default is a static release build.
@rem
@rem   debug             whether emit debug symbols

call make_luajit2_windows.bat x86 %*
