set(LUAJIT_SOURCE_ROOT ${CMAKE_SOURCE_DIR}/luajit-2.1/src)
set(LUAJIT_INSTALL_ROOT ${CMAKE_BINARY_DIR}/lj2)

if (WIN32 AND NOT CYGWIN)
    set(LUAJIT_LIB_PATH ${LUAJIT_INSTALL_ROOT}/lua51.lib)
elseif (IOS)
    set(LUAJIT_LIB_PATH ${LUAJIT_INSTALL_ROOT}/libluajit.a)
else ()
    set(LUAJIT_LIB_PATH ${LUAJIT_INSTALL_ROOT}/libluajit.so)
endif ()

if (WIN32 AND NOT CYGWIN)
    if (CMAKE_GENERATOR MATCHES "Visual Studio")
        if (CMAKE_GENERATOR_PLATFORM STREQUAL "Win32")
            set(LUAJIT_BUILD_SCRIPT_PATH ${CMAKE_SOURCE_DIR}/make_luajit2_windows_x86.bat)
        elseif (CMAKE_GENERATOR_PLATFORM STREQUAL "x64")
            set(LUAJIT_BUILD_SCRIPT_PATH ${CMAKE_SOURCE_DIR}/make_luajit2_windows_x64.bat)
        endif ()
        add_custom_command(
            OUTPUT ${LUAJIT_LIB_PATH}
            COMMAND ${LUAJIT_BUILD_SCRIPT_PATH} $<$<CONFIG:Debug>:debug>
            COMMAND ${CMAKE_COMMAND} -E copy ${LUAJIT_SOURCE_ROOT}/lua51.lib ${LUAJIT_LIB_PATH}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMENT "Building LuaJIT for Windows (${CMAKE_GENERATOR_PLATFORM})..."
        )
    endif ()
elseif (ANDROID)
    # https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-android
    # https://developer.android.com/ndk/guides/cmake#command-line
    # IMPORTANT: Caution: CMake has its own built-in NDK support which has behavior differences compared to 
    # the NDK's CMake toolchain file. Android does not support or test the built-in workflow. We recommend 
    # using our toolchain file.
    if (NOT ANDROID_NDK)
        if (DEFINED ENV{ANDROID_NDK_HOME})
            set(ANDROID_NDK $ENV{ANDROID_NDK_HOME})
        else ()
            message(FATAL_ERROR "ANDROID_NDK is not set.")
        endif ()
    endif ()

    if (NOT (ANDROID_ABI STREQUAL "arm64-v8a"))
        message(FATAL_ERROR "ANDROID_ABI is not arm64-v8a.")
    endif ()

    if (CMAKE_HOST_WIN32)
        set(NDK_BIN_DIR ${ANDROID_NDK}\\toolchains\\llvm\\prebuilt\\windows-x86_64\\bin)
        set(NDK_CROSS ${NDK_BIN_DIR}\\aarch64-linux-android-)
        set(NDK_CC ${NDK_BIN_DIR}\\aarch64-linux-android${ANDROID_PLATFORM}-clang.cmd)
        set(NDK_AR ${NDK_BIN_DIR}\\llvm-ar.exe)
        set(NDK_STRIP ${NDK_BIN_DIR}\\llvm-strip.exe)
    elseif (CMAKE_HOST_UNIX)
        string(TOLOWER ${CMAKE_HOST_SYSTEM_NAME} HOST_SYSTEM_NAME_LOWER)
        set(NDK_BIN_DIR ${ANDROID_NDK}/toolchains/llvm/prebuilt/${HOST_SYSTEM_NAME_LOWER}-x86_64/bin)
        set(NDK_CROSS ${NDK_BIN_DIR}/aarch64-linux-android-)
        set(NDK_CC ${NDK_BIN_DIR}/aarch64-linux-android${ANDROID_PLATFORM}-clang)
        set(NDK_AR ${NDK_BIN_DIR}/llvm-ar)
        set(NDK_STRIP ${NDK_BIN_DIR}/llvm-strip)
    endif ()

    add_custom_command(
        OUTPUT ${LUAJIT_LIB_PATH}
        COMMAND make TARGET_SYS=Linux clean
        COMMAND make
            CROSS=${NDK_CROSS}
            STATIC_CC=${NDK_CC}
            DYNAMIC_CC="${NDK_CC} -fPIC"
            TARGET_LD=${NDK_CC}
            TARGET_AR="${NDK_AR} rcus"
            TARGET_STRIP=${NDK_STRIP}
            TARGET_SYS=Linux
        COMMAND ${CMAKE_COMMAND} -E copy ${LUAJIT_SOURCE_ROOT}/libluajit.so ${LUAJIT_LIB_PATH}
        WORKING_DIRECTORY ${LUAJIT_SOURCE_ROOT}
        COMMENT "Building LuaJIT for Android (${ANDROID_ABI})"
    )
else ()

endif ()

add_custom_target(luajit2_build DEPENDS ${LUAJIT_LIB_PATH})
