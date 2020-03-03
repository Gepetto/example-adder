add_definitions(-DBOOST_TEST_DYN_LINK -DBOOST_TEST_MAIN)

add_unit_test(add add)
target_link_libraries(Add ${PROJECT_NAME})

add_unit_test(boost_add boost_add)
target_link_libraries(boost_add ${PROJECT_NAME} ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
