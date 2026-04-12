function(addTest)
    set(options NO_MAIN)
    set(oneValueArgs COMPONENT_NAME TEST_NAME)
    set(multiValueArgs DEPENDENCIES)

    cmake_parse_arguments(PARSE_ARGV 0 arg 
        "${options}" 
        "${oneValueArgs}" 
        "${multiValueArgs}"
    )

    set(TEST_EXEC_NAME "tst_dynamic_cast_${arg_COMPONENT_NAME}_${arg_TEST_NAME}")
    add_executable("${TEST_EXEC_NAME}" "tst_${arg_TEST_NAME}.cpp")
    add_test(NAME "${TEST_EXEC_NAME}" COMMAND "${TEST_EXEC_NAME}")

    if (arg_NO_MAIN)
      target_link_libraries("${TEST_EXEC_NAME}" PRIVATE Catch2::Catch2)
    else()
      target_link_libraries("${TEST_EXEC_NAME}" PRIVATE Catch2::Catch2WithMain)
    endif()

    target_link_libraries("${TEST_EXEC_NAME}" 
      PRIVATE
        "dynamic_cast::${arg_COMPONENT_NAME}"
        ${arg_DEPENDENCIES}
    )
endfunction()
