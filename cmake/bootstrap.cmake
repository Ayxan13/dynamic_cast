if(CMAKE_CROSSCOMPILING)
    message(STATUS "[dc:bootstrap] Cross-compiling. Qt download skipped. Set Qt6_DIR in CMakeUserPresets.json.")
    return()
endif()

# Options
set(DC_QT_VERSION  "6.11.0" CACHE STRING "Qt version to install via aqt (e.g. 6.7.3, 6.8.2)")
set(DC_QT_BASE_DIR "${CMAKE_SOURCE_DIR}/.qt" CACHE PATH "Directory where aqt downloads Qt installations")
set(DC_VENV_DIR    "${CMAKE_SOURCE_DIR}/.venv" CACHE PATH "Python virtual environment used for aqtinstall")
mark_as_advanced(DC_QT_BASE_DIR DC_VENV_DIR)

# Platform configuration
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    set(_dc_aqt_host   "linux")
    set(_dc_aqt_target "desktop")
    set(_dc_aqt_arch   "linux_gcc_64")
    set(_dc_qt_subdir  "gcc_64")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
    set(_dc_aqt_host   "mac")
    set(_dc_aqt_target "desktop")
    set(_dc_aqt_arch   "clang_64")
    set(_dc_qt_subdir  "macos")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set(_dc_aqt_host   "windows")
    set(_dc_aqt_target "desktop")
    set(_dc_aqt_arch   "win64_msvc2022_64")
    set(_dc_qt_subdir  "msvc2022_64")
else()
    message(WARNING "[dc:bootstrap] Unrecognised host OS '${CMAKE_HOST_SYSTEM_NAME}'. Set Qt6_DIR manually.")
    return()
endif()

set(_dc_qt_install_dir "${DC_QT_BASE_DIR}/${DC_QT_VERSION}/${_dc_qt_subdir}")
set(_dc_qt_cmake_dir   "${_dc_qt_install_dir}/lib/cmake/Qt6")

# Already downloaded, fast path
if(EXISTS "${_dc_qt_cmake_dir}/Qt6Config.cmake")
    message(STATUS "[dc:bootstrap] Qt ${DC_QT_VERSION} found: ${_dc_qt_install_dir}")
    set(Qt6_DIR "${_dc_qt_cmake_dir}" CACHE PATH "Qt6 CMake config directory" FORCE)

    # Prepend install dir so cmake prefers aqt tools (moc, etc.) over any
    # system Qt installation that may be on PATH or in default search paths.
    list(PREPEND CMAKE_PREFIX_PATH "${_dc_qt_install_dir}")
    set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}" CACHE STRING "" FORCE)
    return()
endif()

# Need to download Qt. Set up Python venv + aqtinstall first
message(STATUS "[dc:bootstrap] Qt ${DC_QT_VERSION} not found. Will download via aqtinstall.")

find_package(Python3 REQUIRED COMPONENTS Interpreter)

if(WIN32)
    set(_dc_pip "${DC_VENV_DIR}/Scripts/pip.exe")
    set(_dc_aqt "${DC_VENV_DIR}/Scripts/aqt.exe")
else()
    set(_dc_pip "${DC_VENV_DIR}/bin/pip")
    set(_dc_aqt "${DC_VENV_DIR}/bin/aqt")
endif()

# Create the venv if it doesn't exist
if(NOT EXISTS "${_dc_pip}")
    message(STATUS "[dc:bootstrap] Creating Python venv at ${DC_VENV_DIR}")
    execute_process(
        COMMAND "${Python3_EXECUTABLE}" -m venv "${DC_VENV_DIR}"
        RESULT_VARIABLE _dc_venv_rc
        ERROR_VARIABLE  _dc_venv_err
    )
    if(NOT _dc_venv_rc EQUAL 0)
        message(FATAL_ERROR
            "[dc:bootstrap] Failed to create Python venv:\n${_dc_venv_err}\n On Debian/Ubuntu: sudo apt install python3-venv")
    endif()
endif()

# Install / upgrade aqtinstall inside the venv
message(STATUS "[dc:bootstrap] Installing aqtinstall...")
execute_process(
    COMMAND "${_dc_pip}" install --quiet --upgrade aqtinstall
    RESULT_VARIABLE _dc_pip_rc
    ERROR_VARIABLE  _dc_pip_err
)
if(NOT _dc_pip_rc EQUAL 0)
    message(FATAL_ERROR "[dc:bootstrap] pip install aqtinstall failed:\n${_dc_pip_err}")
endif()

# Assemble the list of extra Qt modules
set(_dc_modules qtmultimedia qtwebsockets qtwebengine qtwebchannel qttasktree)

# Download Qt
message(STATUS "[dc:bootstrap] Downloading Qt ${DC_QT_VERSION} "
               "for ${CMAKE_HOST_SYSTEM_NAME} ${_dc_aqt_arch}. This will take a few minutes on first run...")

file(MAKE_DIRECTORY "${DC_QT_BASE_DIR}")

execute_process(
    COMMAND "${_dc_aqt}" install-qt
        "${_dc_aqt_host}"
        "${_dc_aqt_target}"
        "${DC_QT_VERSION}"
        "${_dc_aqt_arch}"
        -O "${DC_QT_BASE_DIR}"
        -m ${_dc_modules}
    RESULT_VARIABLE _dc_aqt_rc
    OUTPUT_VARIABLE _dc_aqt_out
    ERROR_VARIABLE  _dc_aqt_err
    ECHO_OUTPUT_VARIABLE
    ECHO_ERROR_VARIABLE
)

if(NOT _dc_aqt_rc EQUAL 0)
    message(FATAL_ERROR
        "[dc:bootstrap] aqt failed to download Qt ${DC_QT_VERSION}.\n"
        "Try a different version:  cmake --preset debug -DDC_QT_VERSION=6.8.2\n"
        "Or supply Qt manually:    cmake --preset debug -DQt6_DIR=/path/to/Qt/lib/cmake/Qt6\n"
        "aqt stderr:\n${_dc_aqt_err}")
endif()

# Verify the download
if(NOT EXISTS "${_dc_qt_cmake_dir}/Qt6Config.cmake")
    message(FATAL_ERROR
        "[dc:bootstrap] aqt reported success but Qt6Config.cmake not found at "
        "${_dc_qt_cmake_dir}.\nCheck the output above.")
endif()

message(STATUS "[dc:bootstrap] Qt ${DC_QT_VERSION} downloaded to ${_dc_qt_install_dir}")
set(Qt6_DIR "${_dc_qt_cmake_dir}" CACHE PATH "Qt6 CMake config directory" FORCE)
list(PREPEND CMAKE_PREFIX_PATH "${_dc_qt_install_dir}")
set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}" CACHE STRING "" FORCE)
