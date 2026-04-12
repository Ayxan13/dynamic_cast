function(addTest COMPONENT_NAME TEST_NAME)
    set(TEST_EXEC_NAME "tst_${COMPONENT_NAME}_${TEST_NAME}")
    add_executable("${TEST_EXEC_NAME}" "tst_${TEST_NAME}.cpp")
    add_test(NAME "${TEST_EXEC_NAME}" COMMAND "${TEST_EXEC_NAME}")

    target_link_libraries("${TEST_EXEC_NAME}" 
      PRIVATE
        "dynamic_cast::${COMPONENT_NAME}"
        Catch2::Catch2WithMain  
    )
endfunction()
