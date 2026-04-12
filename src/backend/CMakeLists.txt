include("${CMAKE_SOURCE_DIR}/cmake/component.cmake")

addComponent(backend Qt6::Core Qt6::Network  QCoro6::Core QCoro6::Network)

target_link_libraries(dynamic_cast_backend
    PUBLIC
        dynamic_cast::common
)
