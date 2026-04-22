if(NOT DC_BUILD_TESTING)
    return()
endif()

# Glob gallery QML and assets as absolute paths, then set QT_RESOURCE_ALIAS on
# each file so the resource paths match what the gallery executable expects
# (e.g. "src/GalleryMain.qml" relative to the gallery source root).
file(GLOB_RECURSE GALLERY_TEST_QML CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/../src/*.qml")
file(GLOB_RECURSE GALLERY_TEST_ASSETS CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/../assets/*")

foreach(QML_FILE ${GALLERY_TEST_QML})
    file(RELATIVE_PATH ALIAS "${CMAKE_CURRENT_SOURCE_DIR}/.." "${QML_FILE}")
    set_source_files_properties("${QML_FILE}" PROPERTIES QT_RESOURCE_ALIAS "${ALIAS}")
endforeach()

foreach(ASSET ${GALLERY_TEST_ASSETS})
    file(RELATIVE_PATH ALIAS "${CMAKE_CURRENT_SOURCE_DIR}/.." "${ASSET}")
    set_source_files_properties("${ASSET}" PROPERTIES QT_RESOURCE_ALIAS "${ALIAS}")
endforeach()

set(TEST_NAME tst_dynamic_cast_gallery_ui)

add_executable(${TEST_NAME} tst_gallery_ui.cpp)

qt_add_qml_module(${TEST_NAME}
    URI "DynamicCastGallery"
    VERSION "1.0"
    RESOURCE_PREFIX "/qt/qml"
    QML_FILES ${GALLERY_TEST_QML}
    RESOURCES ${GALLERY_TEST_ASSETS}
)

qt_import_qml_plugins(${TEST_NAME})

target_link_libraries(${TEST_NAME}
    PRIVATE
        dynamic_cast::backend
        dynamic_cast::qml
        dynamic_cast_qmlplugin
        Qt6::Gui Qt6::Core Qt6::Qml Qt6::Quick Qt6::QuickControls2
        QCoro6::Core QCoro6::Network QCoro6::Qml
)

add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})
