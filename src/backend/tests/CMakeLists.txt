include("${CMAKE_SOURCE_DIR}/cmake/addTest.cmake")

addTest(
    COMPONENT_NAME backend 
    TEST_NAME searchprovider 
    DEPENDENCIES Qt6::Network
    NO_MAIN "ON")
