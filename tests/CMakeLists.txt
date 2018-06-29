add_unit_test(add add.cpp)
target_link_libraries(add ${PROJECT_NAME})

add_unit_test(boost_add boost_add.cpp)
target_link_libraries(boost_add PUBLIC ${PROJECT_NAME}
                                       Boost::unit_test_framework)

if(BUILD_PYTHON_INTERFACE)
  add_subdirectory(python)
endif()
