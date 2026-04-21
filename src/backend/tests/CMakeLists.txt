include("${CMAKE_SOURCE_DIR}/cmake/addTest.cmake")

addTest(
    COMPONENT_NAME backend
    TEST_NAME searchprovider
    DEPENDENCIES Qt6::Network
    NO_MAIN "ON")

addTest(
    COMPONENT_NAME backend
    TEST_NAME searchcontroller
    DEPENDENCIES Qt6::Network Qt6::Qml QCoro6::Qml
    NO_MAIN "ON")


addTest(
    COMPONENT_NAME backend
    TEST_NAME feedparser)
