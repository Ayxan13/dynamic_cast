file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "src/*.cpp")

set(LIB_NAME "dynamic_cast_backend")
qt_add_library("${LIB_NAME}" STATIC ${SOURCES})

target_include_directories("${LIB_NAME}" PUBLIC "include")
target_link_libraries("${LIB_NAME}" PUBLIC Qt6::Core)
