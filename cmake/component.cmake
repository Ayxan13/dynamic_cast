function(addComponent COMPONENT_NAME) # Add all the Qt dependencies to be linked (Qt6::Core, etc) as extra arguments
    set(LIB_NAME "dynamic_cast_${COMPONENT_NAME}")
    
    file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "src/*.cpp")

    if(ARGN)
        qt_add_library("${LIB_NAME}" STATIC ${SOURCES})
        target_link_libraries("${LIB_NAME}" PUBLIC ${ARGN})
    else()
        add_library("${LIB_NAME}" STATIC ${SOURCES})
    endif()

    add_library(dynamic_cast::${COMPONENT_NAME} ALIAS ${LIB_NAME})
    target_include_directories("${LIB_NAME}" PUBLIC "include")

    if(BUILD_TESTING)
        add_subdirectory("tests")
    endif()
endfunction()
