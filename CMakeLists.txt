cmake_minimum_required(VERSION 3.25)

project(dynamic_cast VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

include(cmake/bootstrap.cmake)

find_package(Qt6 REQUIRED COMPONENTS
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

# --- Dependencies ---
include(FetchContent)

option(DC_BUILD_TESTING "Build tests" ON)
if (DC_BUILD_TESTING)
    FetchContent_Declare(
      Catch2
      GIT_REPOSITORY https://github.com/catchorg/Catch2.git
      GIT_TAG        v3.7.1
    )

    FetchContent_MakeAvailable(Catch2)
    enable_testing()
endif()

FetchContent_Declare(
    QCoro
    GIT_REPOSITORY https://github.com/danvratil/qcoro.git
    GIT_TAG        v0.13.0
)

set(QCORO_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(QCORO_BUILD_TESTING OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(QCoro)
qcoro_enable_coroutines()


# add_subdirectory(src/core)
add_subdirectory(src/common)
add_subdirectory(src/backend)
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
