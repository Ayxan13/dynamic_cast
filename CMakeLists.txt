cmake_minimum_required(VERSION 3.25)

project(dynamic_cast VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

if(MSVC)
    add_compile_options(
        /GR-    # Disables RTTI
        /EHs-c- # Disables C++ Exceptions
    )
else()
    add_compile_options(-fno-rtti -fno-exceptions)
endif()

include(cmake/bootstrap.cmake)

find_package(Qt6 6.5 REQUIRED COMPONENTS
    Core
    Gui
    Widgets
    Qml
    Quick
    QuickControls2
    Multimedia
    Network
    Sql
    Xml
    Concurrent
)

option(BUILD_TESTING "Build tests" ON)
if (BUILD_TESTING)
    include(FetchContent)

    FetchContent_Declare(
      Catch2
      GIT_REPOSITORY https://github.com/catchorg/Catch2.git
      GIT_TAG        v3.7.1
    )

    FetchContent_MakeAvailable(Catch2)
    enable_testing()
endif()

# add_subdirectory(src/core)
add_subdirectory(src/common)
# add_subdirectory(src/backend)
# add_subdirectory(src/audio)
# add_subdirectory(src/viewmodels)
# add_subdirectory(src/services)
# add_subdirectory(src)

# Symlink compile_commands.json to the source root for clangd
if(CMAKE_EXPORT_COMPILE_COMMANDS)
    file(CREATE_LINK
        "${CMAKE_BINARY_DIR}/compile_commands.json"
        "${CMAKE_SOURCE_DIR}/compile_commands.json"
        SYMBOLIC
    )
endif()
