###
# Copyright (c) 2009, Paul Gideon Dann
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
###

cmake_minimum_required(VERSION 2.8.6)
project(example)
set(PROJECT_LONGNAME "Example")
set(PROJECT_VERSION "0.1")

# If no build type is specified, default to "Release"
if (NOT CMAKE_BUILD_TYPE)
  set (CMAKE_BUILD_TYPE Release)
endif (NOT CMAKE_BUILD_TYPE)

# Configure Qt
find_package(Qt4 REQUIRED QtCore QtGui)
include(${QT_USE_FILE})
set (CMAKE_AUTOMOC true)

# Qt doesn't use exceptions, but remove this if you do.
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions")

# Testing configuration
enable_testing()
set(TEST_LINK_LIBRARIES ${QT_LIBRARIES})

# The support scripts need to generate CMakeLists files before we can continue
find_package(Ruby REQUIRED)
set (SCRIPTS_DIR ${CMAKE_SOURCE_DIR}/scripts)
execute_process(COMMAND ${RUBY_EXECUTABLE} ${SCRIPTS_DIR}/prepare-build
                RESULT_VARIABLE SCRIPT_RESULT)
if (SCRIPT_RESULT)
  message (FATAL_ERROR "Failed to run build-preparation script.")
endif (SCRIPT_RESULT)

add_subdirectory(source)
add_subdirectory(tests)
