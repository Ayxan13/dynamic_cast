file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "src/*.cpp")

qt_add_executable(dynamic_cast ${SOURCES})
qt_import_qml_plugins(dynamic_cast)

target_link_libraries(dynamic_cast
    PRIVATE
        dynamic_cast::common
        dynamic_cast::backend
        dynamic_cast::qml
        dynamic_cast_qmlplugin
        Qt6::Gui Qt6::Core Qt6::Network Qt6::Qml Qt6::Quick QCoro6::Core QCoro6::Network QCoro6::Qml
)

set_target_properties(dynamic_cast PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

if(ANDROID)
    set_target_properties(dynamic_cast PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_SOURCE_DIR}/android"
        QT_ANDROID_TARGET_SDK_VERSION 34
        QT_ANDROID_MIN_SDK_VERSION 26
    )
endif()
