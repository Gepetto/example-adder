cmake_minimum_required(VERSION 3.1)

set(PROJECT_NAMESPACE gepetto)
set(PROJECT_NAME example-adder)
set(PROJECT_DESCRIPTION "This is an example project, to show how to use Gepetto's tools")
set(PROJECT_URL https://gepgitlab.laas.fr/${PROJECT_NAMESPACE}/${PROJECT_NAME})

option(BUILD_PYTHON_INTERFACE "Build the python binding" ON)
option(INSTALL_PYTHON_INTERFACE_ONLY "Install *ONLY* the python bindings" OFF)

include(cmake/base.cmake)
include(cmake/boost.cmake)
include(cmake/test.cmake)
include(cmake/python.cmake)

compute_project_args(PROJECT_ARGS LANGUAGES CXX)
project(${PROJECT_NAME} ${PROJECT_ARGS})

set(BOOST_COMPONENTS unit_test_framework)

if(BUILD_PYTHON_INTERFACE)
  findpython()
  string(REGEX REPLACE "-" "_" PY_NAME ${PROJECT_NAME})
  set(${PY_NAME}_INSTALL_DIR ${PYTHON_SITELIB}/${PY_NAME})
  set(BOOST_COMPONENTS ${BOOST_COMPONENTS} python)
  include_directories(SYSTEM ${PYTHON_INCLUDE_DIRS})
endif(BUILD_PYTHON_INTERFACE)

search_for_boost()
include_directories(SYSTEM ${Boost_INCLUDE_DIRS})

add_subdirectory(include/${PROJECT_NAME})
add_subdirectory(src)
add_subdirectory(tests)
add_subdirectory(bindings)
