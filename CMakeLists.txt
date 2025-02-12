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
    ${LUASOCKET_SRC}
)
set_property(SOURCE ${LIB_SRC} PROPERTY COMPILE_DEFINITIONS LUA_LIB)

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

# Depends on LuaJIT
include(${CMAKE_SOURCE_DIR}/cmake/luajit2.cmake)

add_library(luajit2 STATIC IMPORTED)
set_target_properties(luajit2 PROPERTIES 
    IMPORTED_LOCATION ${LUAJIT_LIB_PATH}
)
add_dependencies(luajit2 luajit2_build)

# Target options
if (MSVC)
    set_property(TARGET tolua PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif ()
if (WIN32 AND NOT CYGWIN)
    target_compile_definitions(tolua PRIVATE LUA_BUILD_AS_DLL)
endif ()

# Link LuaJIT
target_link_libraries(tolua PRIVATE "$<LINK_LIBRARY:WHOLE_ARCHIVE,luajit2>")
if (CMAKE_C_COMPILER_ID STREQUAL "GNU")
    target_link_options(tolua PRIVATE -Wl,--export-all-symbols)
endif ()
target_include_directories(tolua PRIVATE ${LUAJIT_SOURCE_ROOT})
