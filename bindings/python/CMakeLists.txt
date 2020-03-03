set(${PY_NAME}_SOURCES
  gepadd
  )

add_library(${PY_NAME} SHARED ${${PY_NAME}_SOURCES})
target_link_libraries(${PY_NAME} ${PROJECT_NAME})
target_link_boost_python(${PY_NAME})
install(TARGETS ${PY_NAME} DESTINATION ${${PY_NAME}_INSTALL_DIR})

set(${PY_NAME}_PYTHON
  __init__.py
  )

install(FILES ${${PY_NAME}_PYTHON} DESTINATION ${${PY_NAME}_INSTALL_DIR})

add_python_unit_test("py-add" "bindings/python/test_add.py" "bindings/python")
