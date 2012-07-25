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
  set(CMAKE_BUILD_TYPE Release CACHE STRING
      "None Debug Release RelWithDebInfo MinSizeRel"
      FORCE)
endif (NOT CMAKE_BUILD_TYPE)

# Configure Qt
find_package(Qt4 REQUIRED QtCore QtGui)
include(${QT_USE_FILE})
set(CMAKE_AUTOMOC true)

# Qt doesn't use exceptions, but remove this if you do.
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions")

if (WIN32)
  # Stock Qt is built using the C++03 standard. To avoid potential breakage,
  # let's make this explicit.
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++03")
  # Since Qt doesn't use shared libstdc++, let's avoid it too.
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libstdc++")
  # Windows installer
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/win/installer.nsi.cmake
                 ${CMAKE_CURRENT_BINARY_DIR}/installer.nsi @ONLY)
endif (WIN32)

# Testing configuration
enable_testing()
set(TEST_LINK_LIBRARIES ${QT_LIBRARIES})

add_subdirectory(source)
add_subdirectory(tests)
