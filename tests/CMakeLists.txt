add_unit_test(add add.cpp)
target_link_libraries(add ${PROJECT_NAME}::${PROJECT_NAME})

add_unit_test(boost_add boost_add.cpp)
target_link_libraries(boost_add PRIVATE ${PROJECT_NAME}::${PROJECT_NAME}
                                        Boost::headers)

add_test(NAME exe-fail
         COMMAND ${CMAKE_BINARY_DIR}/${PROJECT_NAMESPACE}-${PROJECT_NAME} 3 4)

if(BUILD_PYTHON_INTERFACE)
  add_subdirectory(python)
endif()
