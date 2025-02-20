set(LUAJIT_SOURCE_ROOT ${CMAKE_SOURCE_DIR}/luajit-2.1/src)
set(LUAJIT_INSTALL_ROOT ${CMAKE_BINARY_DIR}/lj2)

set(LUAJIT_LIB_BASE_NAME "luajit")
set(LUAJIT_LIB_SUFFIX "")
set(LUAJIT_LIB_PREFIX "")
if (WIN32)
    if (CYGWIN OR MINGW)
        set(LUAJIT_LIB_SUFFIX ".a")
        set(LUAJIT_LIB_PREFIX "lib")
    else()
        set(LUAJIT_LIB_BASE_NAME "lua51")
        set(LUAJIT_LIB_SUFFIX ".lib")
    endif()
else ()
    set(LUAJIT_LIB_SUFFIX ".a")
    set(LUAJIT_LIB_PREFIX "lib")
endif()
set(LUAJIT_LIB_NAME "${LUAJIT_LIB_PREFIX}${LUAJIT_LIB_BASE_NAME}${LUAJIT_LIB_SUFFIX}")
set(LUAJIT_LIB_PATH ${LUAJIT_INSTALL_ROOT}/${LUAJIT_LIB_NAME})

# Setup LuaJIT compile flags `XCFLAGS` according to options
set(LUAJIT_XCFLAGS )
if (NOT LJ_GC64)
    set(LUAJIT_XCFLAGS "${LUAJIT_XCFLAGS} -DLUAJIT_DISABLE_GC64")
endif ()
if (LJ_ENABLE_LUA52COMPAT)
    set(LUAJIT_XCFLAGS "${LUAJIT_XCFLAGS} -DLUAJIT_ENABLE_LUA52COMPAT")
endif ()

set(MSYSTEM $ENV{MSYSTEM})

if (WIN32 AND NOT CYGWIN)
    # LuaJIT compiler options (other than LUAJIT_DISABLE_GC64) using Makefile are not supported.
    if (CMAKE_GENERATOR MATCHES "Visual Studio")
        set(SUPPORTED_GENERATOR_PLATFORMS Win32 x64 ARM64)
        string(TOLOWER ${CMAKE_GENERATOR_PLATFORM} PLATFORM_ARCH)
        if (${CMAKE_GENERATOR_PLATFORM} IN_LIST SUPPORTED_GENERATOR_PLATFORMS)
            set(LUAJIT_BUILD_SCRIPT_PATH ${CMAKE_SOURCE_DIR}/make_luajit2_windows_${PLATFORM_ARCH}.bat)
            add_custom_command(
                OUTPUT ${LUAJIT_LIB_PATH}
                COMMAND cmd /C ${LUAJIT_BUILD_SCRIPT_PATH} $<$<NOT:$<BOOL:${LJ_GC64}>>:nogc64> $<$<CONFIG:Debug>:debug>
                COMMAND ${CMAKE_COMMAND} -E copy ${LUAJIT_SOURCE_ROOT}/lua51.lib ${LUAJIT_LIB_PATH}
                WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                COMMENT "Building LuaJIT for Windows (${CMAKE_GENERATOR_PLATFORM})..."
            )
        else ()
            message(FATAL_ERROR "Platforms supported: ${SUPPORTED_GENERATOR_PLATFORMS}. Current: ${CMAKE_GENERATOR_PLATFORM}")
        endif ()
    elseif (MINGW)
        set(SUPPORTED_MSYSTEMS MINGW32 MINGW64)
        set(TARGET_ARCHS x86 x86_64)
        list(FIND SUPPORTED_MSYSTEMS "${MSYSTEM}" MSYSTEM_INDEX)
        if (MSYSTEM_INDEX EQUAL -1)
            message(FATAL_ERROR "MSYS environments supported: ${MSYSTEMS}. Current: ${MSYSTEM}")
        endif ()

        list(GET TARGET_ARCHS ${MSYSTEM_INDEX} TARGET_ARCH)
        add_custom_command(
            OUTPUT ${LUAJIT_LIB_PATH}
            COMMAND make clean
            COMMAND make 
                $<$<EQUAL:${CMAKE_SIZEOF_VOID_P},4>:CC="gcc -m32">
                CCDEBUG="$<$<CONFIG:Debug>: -g>"
                XCFLAGS=${LUAJIT_XCFLAGS}
                BUILDMODE=static
            COMMAND ${CMAKE_COMMAND} -E copy ${LUAJIT_SOURCE_ROOT}/libluajit.a ${LUAJIT_LIB_PATH}
            WORKING_DIRECTORY ${LUAJIT_SOURCE_ROOT}
            COMMENT "Building LuaJIT for Windows (${TARGET_ARCH}) on $ENV{MSYSTEM}..."
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
    file(TO_CMAKE_PATH "${ANDROID_NDK}" ANDROID_NDK)

    set(ANDROID_ARCHS arm64-v8a armeabi-v7a)
    list(FIND ANDROID_ARCHS ${ANDROID_ABI} ARCH_INDEX)
    if (ARCH_INDEX EQUAL -1)
        message(FATAL_ERROR "Android ABIs supported: $ANDROID_ARCHS}. Current: ${ANDROID_ABI}")
    endif ()

    # https://stackoverflow.com/a/47896799/3614952
    set(MAKE_SHELL_CMD 0)
    if (CMAKE_HOST_WIN32)
        if ("${MSYSTEM}" STREQUAL "")
            set(MAKE_SHELL_CMD 1)
        endif ()
    endif ()

    string(TOLOWER ${CMAKE_HOST_SYSTEM_NAME} HOST_SYSTEM_NAME_LOWER)
    set(NDK_MAKE ${ANDROID_NDK}/prebuilt/${HOST_SYSTEM_NAME_LOWER}-x86_64/bin/make)
    set(NDK_BIN_DIR ${ANDROID_NDK}/toolchains/llvm/prebuilt/${HOST_SYSTEM_NAME_LOWER}-x86_64/bin)
    set(NDK_CROSS_ARCHS
        ${NDK_BIN_DIR}/aarch64-linux-android-
        ${NDK_BIN_DIR}/arm-linux-androideabi-
    )
    set(NDK_CC_ARCHS
        ${NDK_BIN_DIR}/aarch64-linux-android${ANDROID_PLATFORM}-clang
        ${NDK_BIN_DIR}/armv7a-linux-androideabi${ANDROID_PLATFORM}-clang
    )
    list(GET NDK_CROSS_ARCHS ${ARCH_INDEX} NDK_CROSS)
    list(GET NDK_CC_ARCHS ${ARCH_INDEX} NDK_CC)
    set(NDK_AR ${NDK_BIN_DIR}/llvm-ar)
    set(NDK_STRIP ${NDK_BIN_DIR}/llvm-strip)

    # https://stackoverflow.com/questions/70594767/cmake-appends-backslash-to-command-added-by-add-custom-target
    set(NDK_DYNAMIC_CC ${NDK_CC} "-fPIC")
    set(NDK_TARGET_AR ${NDK_AR} "rcus")
    add_custom_command(
        OUTPUT ${LUAJIT_LIB_PATH}
        COMMAND ${NDK_MAKE} 
            $<${MAKE_SHELL_CMD}:SHELL=cmd>
            TARGET_SYS=Linux
            clean
        COMMAND ${NDK_MAKE} 
            $<${MAKE_SHELL_CMD}:SHELL=cmd>
            $<$<IN_LIST:${ARCH_INDEX},1>:HOST_CC="gcc -m32">
            CROSS=${NDK_CROSS}
            STATIC_CC=${NDK_CC}
            DYNAMIC_CC="${NDK_DYNAMIC_CC}"
            CCDEBUG="$<$<CONFIG:Debug>: -g>"
            XCFLAGS=${LUAJIT_XCFLAGS}
            $<$<IN_LIST:${ARCH_INDEX},1>:TARGET_CFLAGS="-mcpu=cortex-a9 -mfloat-abi=softfp">
            TARGET_LD=${NDK_CC}
            TARGET_AR="${NDK_TARGET_AR}"
            TARGET_STRIP=${NDK_STRIP}
            TARGET_SYS=Linux
        COMMAND ${CMAKE_COMMAND} -E copy ${LUAJIT_SOURCE_ROOT}/libluajit.a ${LUAJIT_LIB_PATH}
        WORKING_DIRECTORY ${LUAJIT_SOURCE_ROOT}
        COMMENT "Building LuaJIT for Android (${ANDROID_ABI})"
    )
elseif (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    if (CMAKE_OSX_ARCHITECTURES STREQUAL "x86_64;arm64")
        set(LUAJIT_BUILD_SCRIPT_PATH ${CMAKE_SOURCE_DIR}/make_luajit2_osx_universal.sh)
    else ()
        message(FATAL_ERROR "Only universal (x86_64;arm64) is supported.")
    endif ()
    add_custom_command(
        OUTPUT ${LUAJIT_LIB_PATH}
        COMMAND ${CMAKE_COMMAND} -E env MACOSX_DEPLOYMENT_TARGET=${DEPLOYMENT_TARGET} LUAJIT_XCFLAGS=${LUAJIT_XCFLAGS}
                ${LUAJIT_BUILD_SCRIPT_PATH} $<$<CONFIG:Debug>:--debug>
        COMMAND ${CMAKE_COMMAND} -E copy ${LUAJIT_SOURCE_ROOT}/libluajit.a ${LUAJIT_LIB_PATH}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Building LuaJIT for macOS (${CMAKE_OSX_ARCHITECTURES})"
    )
elseif (IOS)
    if (CMAKE_OSX_ARCHITECTURES STREQUAL "arm64")
        set(LUAJIT_BUILD_SCRIPT_PATH ${CMAKE_SOURCE_DIR}/make_luajit2_ios_arm64.sh)
    else ()
        message(FATAL_ERROR "Only arm64 is supported.")
    endif ()
    add_custom_command(
        OUTPUT ${LUAJIT_LIB_PATH}
        COMMAND /bin/sh -c "env -i LUAJIT_XCFLAGS='${LUAJIT_XCFLAGS}' ${LUAJIT_BUILD_SCRIPT_PATH} $<$<CONFIG:Debug>:--debug> --ios-deployment-target ${DEPLOYMENT_TARGET}"
        COMMAND ${CMAKE_COMMAND} -E copy ${LUAJIT_SOURCE_ROOT}/libluajit.a ${LUAJIT_LIB_PATH}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Building LuaJIT for iOS (${CMAKE_OSX_ARCHITECTURES})"
    )
endif ()

add_custom_target(luajit2_build DEPENDS ${LUAJIT_LIB_PATH})
