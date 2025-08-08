cmake_minimum_required(VERSION 3.24)

cmake_policy(SET CMP0091 NEW)

project(tolua LANGUAGES C)

# Options
option(LJ_GC64 "LuaJIT: Use 64 bit GC objects" ON)
option(LJ_ENABLE_LUA52COMPAT "LuaJIT: Enable Lua 5.2 compatibility" OFF)

# Sources
set(TOLUA_SRC
    tolua.c
    int64.c
    uint64.c
)
source_group(tolua FILES ${TOLUA_SRC})

set(LPEG_SRC
    lpeg/lpcap.c
    lpeg/lpcode.c
    lpeg/lpcset.c
    lpeg/lpprint.c
    lpeg/lptree.c
    lpeg/lpvm.c
)
source_group(liblpeg FILES ${LPEG_SRC})

set(STRUCT_SRC
    struct.c
)
source_group(libstruct FILES ${STRUCT_SRC})

set(CJSON_SRC
    cjson/strbuf.c
    cjson/lua_cjson.c
    cjson/fpconv.c
)
source_group(libcjson FILES ${CJSON_SRC})

set(PROTOBUF_SRC
    pb.c
)
source_group(libprotobuf FILES ${PROTOBUF_SRC})

set(LUASOCKET_SRC
    luasocket/src/auxiliar.c
    luasocket/src/buffer.c
    luasocket/src/compat.c
    luasocket/src/except.c
    luasocket/src/inet.c
    luasocket/src/io.c
    luasocket/src/luasocket.c
    luasocket/src/options.c
    luasocket/src/select.c
    luasocket/src/tcp.c
    luasocket/src/timeout.c
    luasocket/src/udp.c
)
if (WIN32 AND NOT CYGWIN)
    list(APPEND LUASOCKET_SRC luasocket/src/wsocket.c)
else()
    list(APPEND LUASOCKET_SRC luasocket/src/usocket.c)
endif()
source_group(libluasocket FILES ${LUASOCKET_SRC})

set(LIB_SRC 
    ${LPEG_SRC}
    ${STRUCT_SRC}
    ${CJSON_SRC}
    ${PROTOBUF_SRC}
    ${LUASOCKET_SRC}
)
set_property(SOURCE ${LIB_SRC} PROPERTY COMPILE_DEFINITIONS LUA_LIB)

add_subdirectory(luajit-2.1)
# toLua Library
if (WIN32 AND NOT CYGWIN)
    add_library(tolua SHARED
        ${TOLUA_SRC}
        ${LIB_SRC}
    )
    target_link_libraries(tolua PRIVATE ws2_32)
elseif (IOS)
    add_library(tolua STATIC
        ${TOLUA_SRC}
        ${LIB_SRC}
    )
    target_link_options(tolua PRIVATE -ObjC)
elseif (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    add_library(tolua MODULE
        ${TOLUA_SRC}
        ${LIB_SRC}
    )
    set_property(TARGET tolua PROPERTY BUNDLE TRUE)
else ()
    add_library(tolua SHARED
        ${TOLUA_SRC}
        ${LIB_SRC}
    )
endif ()
set_property(TARGET tolua PROPERTY C_STANDARD 99)

# Target options
if (MSVC)
    set_property(TARGET tolua PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
endif ()
# toLua Library - 针对 macOS 优化
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    # 符号可见性控制
    target_compile_options(tolua PRIVATE 
        -fvisibility=hidden
        -fvisibility-inlines-hidden
    )
    
    # 链接时优化和符号剥离
    target_link_options(tolua PRIVATE
        "$<$<CONFIG:Release>:LINKER:-dead_strip>"
        "$<$<CONFIG:Release>:LINKER:-x>"
        "$<$<CONFIG:Release>:-Wl,-S>"  # 自动剥离调试符号
    )

    # 添加后处理命令 - 手动剥离符号
    add_custom_command(TARGET tolua POST_BUILD
        COMMAND strip -Sx "$<TARGET_FILE:tolua>"
        COMMENT "Stripping symbols from macOS binary"
        VERBATIM
    )
    
    # 签名设置
    add_custom_command(TARGET tolua POST_BUILD
        COMMAND codesign --force --sign - "$<TARGET_FILE:tolua>"
        COMMENT "Ad-hoc signing macOS binary"
        VERBATIM
    )
elseif (WIN32 AND NOT CYGWIN)
    set(CMAKE_C_FLAGS "/utf-8")
    target_compile_definitions(tolua PRIVATE LUA_BUILD_AS_DLL LUA_CORE)
endif ()

# Link LuaJIT
set(LUAJIT_BUILD_TOOL OFF CACHE BOOL "Build the executable of LuaJIT" FORCE)
include_directories(${CMAKE_SOURCE_DIR}/luajit-2.1/src)
target_include_directories(tolua PRIVATE ${CMAKE_SOURCE_DIR}/luajit-2.1/)

if ( WIN32 AND NOT CYGWIN )
    target_compile_definitions(libluajit PRIVATE LUA_BUILD_AS_DLL)
endif()
target_link_libraries(tolua PRIVATE "$<LINK_LIBRARY:WHOLE_ARCHIVE,libluajit>")

if (CMAKE_C_COMPILER_ID STREQUAL "GNU")
    target_link_options(tolua PRIVATE -Wl,--export-all-symbols)
endif ()
if (IOS)
    add_custom_command(TARGET tolua POST_BUILD
        COMMAND /usr/bin/libtool -static -o $<TARGET_FILE:tolua> $<TARGET_FILE:tolua>
    )
elseif (ANDROID)
    set_target_properties(tolua PROPERTIES
        LINK_FLAGS_RELEASE "-s"  # 自动剥离符号
        ANDROID_CPP_FEATURES "rtti exceptions"  # 明确控制特性
    )
endif ()

# if (NOT CMAKE_CROSSCOMPILING)
#     set (EXEC_SRC_DIR
#         ${TOLUA_SRC}
#         ${LIB_SRC}
#         ${CMAKE_SOURCE_DIR}/luajit-2.1/src/luajit.c
#     )
#     add_executable(lua ${EXEC_SRC_DIR})
#     if (WIN32 AND NOT CYGWIN)
#         target_compile_definitions(lua PRIVATE LUA_BUILD_AS_DLL LUA_CORE)
#     endif ()
#     target_include_directories(lua PRIVATE ${CMAKE_BINARY_DIR}/luajit-2.1/src)
#     target_link_libraries(lua PRIVATE libluajit)
#     if(WIN32)
#       target_link_libraries(lua PRIVATE wsock32 ws2_32)
#   endif()
# endif()