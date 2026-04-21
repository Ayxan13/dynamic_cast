file(GLOB_RECURSE QML_SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} CONFIGURE_DEPENDS "src/*.qml")
file(GLOB_RECURSE FONTS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} CONFIGURE_DEPENDS "assets/*.ttf")

set_source_files_properties(src/Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(src/AppNavigation.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_library(dynamic_cast_qml STATIC)
qt_add_qml_module(dynamic_cast_qml
    URI "DynamicCast"
    VERSION "1.0"
    RESOURCE_PREFIX "/qt/qml"
    QML_FILES ${QML_SRC}
    RESOURCES ${FONTS}
)

add_library(dynamic_cast::qml ALIAS dynamic_cast_qml)
