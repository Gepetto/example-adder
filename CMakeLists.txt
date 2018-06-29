cmake_minimum_required(VERSION 3.22)

# Project properties
set(PROJECT_NAMESPACE gepetto)
set(PROJECT_NAME example-adder)
set(PROJECT_DESCRIPTION
    "This is an example project, to show how to use Gepetto's tools"
)
set(PROJECT_URL https://github.com/${PROJECT_NAMESPACE}/${PROJECT_NAME})

# Project options
option(BUILD_PYTHON_INTERFACE "Build the python binding" ON)
option(BUILD_SHARED_LIBS "Build using shared libraries" ON)

# Project configuration
set(PROJECT_USE_CMAKE_EXPORT TRUE)
set(CUSTOM_HEADER_DIR ${PROJECT_NAME})

# JRL-cmakemodule setup
find_package(jrl-cmakemodules REQUIRED CONFIG)
get_property(
    JRL_CMAKE_MODULES
    TARGET jrl-cmakemodules::jrl-cmakemodules
    PROPERTY INTERFACE_INCLUDE_DIRECTORIES
)
include("${JRL_CMAKE_MODULES}/base.cmake")
include("${JRL_CMAKE_MODULES}/python.cmake")

# Project definition
compute_project_args(PROJECT_ARGS LANGUAGES CXX)
project(${PROJECT_NAME} ${PROJECT_ARGS})
check_minimal_cxx_standard(17 ENFORCE)

# Project dependencies
set(BOOST_COMPONENTS)

if(BUILD_TESTING)
    set(BOOST_COMPONENTS ${BOOST_COMPONENTS} unit_test_framework)
endif()

if(BUILD_PYTHON_INTERFACE)
  set(BOOST_COMPONENTS ${BOOST_COMPONENTS} python)
  set(PYTHON_COMPONENTS Interpreter Development.Module)
  findpython()
  string(REGEX REPLACE "-" "_" PY_NAME ${PROJECT_NAME})
  set(${PY_NAME}_INSTALL_DIR ${PYTHON_SITELIB}/${PY_NAME})
endif()

if(BOOST_COMPONENTS)
    find_package(Boost REQUIRED COMPONENTS ${BOOST_COMPONENTS})
endif()

# Main Library
set(${PROJECT_NAME}_HEADERS include/${PROJECT_NAME}/gepadd.hpp
                            include/${PROJECT_NAME}/python.hpp)

set(${PROJECT_NAME}_SOURCES src/gepadd.cpp)

add_library(
    ${PROJECT_NAME}
    ${${PROJECT_NAME}_SOURCES}
    ${${PROJECT_NAME}_HEADERS}
)
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
target_include_directories(
    ${PROJECT_NAME}
    PUBLIC $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Main Executable
add_executable(${PROJECT_NAMESPACE}-${PROJECT_NAME} src/main.cpp)
target_link_libraries(
    ${PROJECT_NAMESPACE}-${PROJECT_NAME}
    ${PROJECT_NAME}::${PROJECT_NAME}
)

if(UNIX)
    get_relative_rpath(${CMAKE_INSTALL_BINDIR}
                       ${PROJECT_NAMESPACE}-${PROJECT_NAME}_INSTALL_RPATH
    )
    set_target_properties(
        ${PROJECT_NAMESPACE}-${PROJECT_NAME}
        PROPERTIES
            INSTALL_RPATH
                "${${PROJECT_NAMESPACE}-${PROJECT_NAME}_INSTALL_RPATH}"
    )
endif()

# Python Bindings
if(BUILD_PYTHON_INTERFACE)
  add_subdirectory(python)
endif()

# Unit tests
if(BUILD_TESTING)
    add_subdirectory(tests)
endif()

# Installation
install(
    TARGETS ${PROJECT_NAME}
    EXPORT ${TARGETS_EXPORT_NAME}
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
install(
    TARGETS ${PROJECT_NAMESPACE}-${PROJECT_NAME}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
