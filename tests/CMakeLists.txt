add_unit_test(add add.cpp)
target_link_libraries(add ${PROJECT_NAME}::${PROJECT_NAME})

add_unit_test(boost_add boost_add.cpp)
target_link_libraries(boost_add PRIVATE ${PROJECT_NAME}::${PROJECT_NAME}
                                        Boost::headers)
