cmake_minimum_required(VERSION 3.22)

# Project properties
set(PROJECT_NAMESPACE gepetto)
set(PROJECT_NAME example-adder)
set(PROJECT_DESCRIPTION
    "This is an example project, to show how to use Gepetto's tools"
)
set(PROJECT_URL https://github.com/${PROJECT_NAMESPACE}/${PROJECT_NAME})

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

# Project definition
compute_project_args(PROJECT_ARGS LANGUAGES CXX)
project(${PROJECT_NAME} ${PROJECT_ARGS})
check_minimal_cxx_standard(17 ENFORCE)
