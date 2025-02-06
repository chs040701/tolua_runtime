set(LUAJIT_SOURCE_ROOT ${CMAKE_SOURCE_DIR}/luajit-2.1/src)
set(LUAJIT_BUILD_ROOT ${CMAKE_BINARY_DIR}/lj2)

if (WIN32)
    set(LUAJIT_LIB_PATH ${LUAJIT_SOURCE_ROOT}/lua51.lib)
else ()
    set(LUAJIT_LIB_PATH ${LUAJIT_SOURCE_ROOT}/libluajit.a)
endif ()

if (CMAKE_GENERATOR MATCHES "Visual Studio")
    if (CMAKE_GENERATOR_PLATFORM STREQUAL "Win32")
        set(LUAJIT_BUILD_WIN32_PATH ${CMAKE_SOURCE_DIR}/make_luajit2_windows_x86.bat)
    elseif (CMAKE_GENERATOR_PLATFORM STREQUAL "x64")
        set(LUAJIT_BUILD_WIN32_PATH ${CMAKE_SOURCE_DIR}/make_luajit2_windows_x64.bat)
    endif ()
    add_custom_command(
        OUTPUT ${LUAJIT_LIB_PATH}
        COMMAND ${LUAJIT_BUILD_WIN32_PATH}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Building LuaJIT for Windows (${CMAKE_GENERATOR_PLATFORM})..."
    )
else ()

endif ()

add_custom_target(luajit2_build DEPENDS ${LUAJIT_LIB_PATH})