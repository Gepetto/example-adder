cmake_minimum_required(VERSION 3.10)

# Project properties
set(PROJECT_NAMESPACE gepetto)
set(PROJECT_NAME example-adder)
set(PROJECT_DESCRIPTION
    "This is an example project, to show how to use Gepetto's tools")
set(PROJECT_URL https://github.com/${PROJECT_NAMESPACE}/${PROJECT_NAME})

# Project options
option(BUILD_PYTHON_INTERFACE "Build the python binding" ON)
option(SUFFIX_SO_VERSION "Suffix library name with its version" ON)

# Project configuration
set(PROJECT_USE_CMAKE_EXPORT TRUE)
set(CUSTOM_HEADER_DIR ${PROJECT_NAME})

# Check if the submodule cmake have been initialized
set(JRL_CMAKE_MODULES "${CMAKE_CURRENT_LIST_DIR}/cmake")
if(EXISTS "${JRL_CMAKE_MODULES}/base.cmake")
  message(STATUS "JRL cmakemodules found in 'cmake/' git submodule")
else()
  find_package(jrl-cmakemodules QUIET CONFIG)
  if(jrl-cmakemodules_FOUND)
    get_property(
      JRL_CMAKE_MODULES
      TARGET jrl-cmakemodules::jrl-cmakemodules
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
    message(STATUS "JRL cmakemodules found on system at ${JRL_CMAKE_MODULES}")
  elseif(${CMAKE_VERSION} VERSION_LESS "3.14.0")
    message(
      FATAL_ERROR
        "\nCan't find jrl-cmakemodules. Please either:\n"
        "  - use git submodule: 'git submodule update --init'\n"
        "  - or install https://github.com/jrl-umi3218/jrl-cmakemodules\n"
        "  - or upgrade your CMake version to >= 3.14 to allow automatic fetching\n"
    )
  else()
    message(STATUS "JRL cmakemodules not found. Let's fetch it.")
    include(FetchContent)
    FetchContent_Declare(
      "jrl-cmakemodules"
      GIT_REPOSITORY "https://github.com/jrl-umi3218/jrl-cmakemodules.git")
    FetchContent_MakeAvailable("jrl-cmakemodules")
    FetchContent_GetProperties("jrl-cmakemodules" SOURCE_DIR JRL_CMAKE_MODULES)
  endif()
endif()

# JRL-cmakemodule setup
include("${JRL_CMAKE_MODULES}/base.cmake")
include("${JRL_CMAKE_MODULES}/boost.cmake")
include("${JRL_CMAKE_MODULES}/python.cmake")

# Project definition
compute_project_args(PROJECT_ARGS LANGUAGES CXX)
project(${PROJECT_NAME} ${PROJECT_ARGS})

# Project dependencies
find_package(Boost REQUIRED COMPONENTS unit_test_framework)

if(BUILD_PYTHON_INTERFACE)
  set(PYTHON_COMPONENTS Interpreter Development.Module)
  findpython()
  string(REGEX REPLACE "-" "_" PY_NAME ${PROJECT_NAME})
  set(${PY_NAME}_INSTALL_DIR ${PYTHON_SITELIB}/${PY_NAME})
  search_for_boost_python()
endif()

# Main Library
set(${PROJECT_NAME}_HEADERS include/${PROJECT_NAME}/gepadd.hpp
                            include/${PROJECT_NAME}/python.hpp)

set(${PROJECT_NAME}_SOURCES src/gepadd.cpp)

add_library(${PROJECT_NAME} SHARED ${${PROJECT_NAME}_SOURCES}
                                   ${${PROJECT_NAME}_HEADERS})
target_include_directories(
  ${PROJECT_NAME} PUBLIC $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

if(SUFFIX_SO_VERSION)
  set_target_properties(${PROJECT_NAME} PROPERTIES SOVERSION ${PROJECT_VERSION})
endif()

# Main Executable
add_executable(${PROJECT_NAMESPACE}-${PROJECT_NAME} src/main.cpp)
target_link_libraries(${PROJECT_NAMESPACE}-${PROJECT_NAME} ${PROJECT_NAME})

if(UNIX)
  get_relative_rpath(${CMAKE_INSTALL_BINDIR}
                     ${PROJECT_NAMESPACE}-${PROJECT_NAME}_INSTALL_RPATH)
  set_target_properties(
    ${PROJECT_NAMESPACE}-${PROJECT_NAME}
    PROPERTIES INSTALL_RPATH
               "${${PROJECT_NAMESPACE}-${PROJECT_NAME}_INSTALL_RPATH}")
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
  DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(TARGETS ${PROJECT_NAMESPACE}-${PROJECT_NAME}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES package.xml DESTINATION share/${PROJECT_NAME})
