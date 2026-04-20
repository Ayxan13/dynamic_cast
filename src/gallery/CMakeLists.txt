file(GLOB_RECURSE QML_SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} CONFIGURE_DEPENDS "src/*.qml")
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "src/*.cpp")
file(GLOB_RECURSE ASSETS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} CONFIGURE_DEPENDS "assets/*")

qt_add_executable(gallery ${SOURCES})

qt_add_qml_module(gallery
    URI "DynamicCastGallery"
    VERSION "1.0"
    RESOURCE_PREFIX "/qt/qml"
    QML_FILES ${QML_SRC}
    RESOURCES ${ASSETS}
)

qt_import_qml_plugins(gallery)

target_link_libraries(gallery
    PRIVATE
        dynamic_cast::qml
        dynamic_cast_qmlplugin
        Qt6::Gui Qt6::Core Qt6::Qml Qt6::Quick Qt6::QuickControls2
)
