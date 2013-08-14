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

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/defines.h.cmake
               ${CMAKE_CURRENT_BINARY_DIR}/defines.h)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../source)

set(TEST_ROOT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
string(LENGTH ${TEST_ROOT_DIRECTORY} TEST_ROOT_DIRECTORY_LENGTH)
math(EXPR TEST_ROOT_DIRECTORY_LENGTH "${TEST_ROOT_DIRECTORY_LENGTH} + 1")

function(test_directory)
  include_directories(${CMAKE_CURRENT_BINARY_DIR})

  file(GLOB TEST_FILES *_tests.cpp)
  foreach(TEST_FILE ${TEST_FILES})
    # The name of the test should contain the directory, relative to the test
    # directory root
    string(SUBSTRING ${TEST_FILE} ${TEST_ROOT_DIRECTORY_LENGTH} -1
           TEST_FILE_RELATIVE)
    string(LENGTH ${TEST_FILE_RELATIVE} TEST_FILE_RELATIVE_LENGTH)
    math(EXPR TEST_NAME_LENGTH "${TEST_FILE_RELATIVE_LENGTH} - 4")
    string(SUBSTRING ${TEST_FILE_RELATIVE} 0 ${TEST_NAME_LENGTH} TEST_NAME)

    get_filename_component(TEST_TARGET ${TEST_FILE} NAME_WE)

    add_executable(${TEST_TARGET} ${TEST_FILE})
    target_link_libraries(${TEST_TARGET} ${TEST_LINK_LIBRARIES})
    add_test(${TEST_NAME} ${TEST_TARGET})
  endforeach(TEST_FILE)

  # Descend into any subdirectories that have CMakeLists.txt files. Each of
  # those should generally simply include a call to test_directory().
  file(GLOB SUBDIRECTORIES *)
  foreach (SUBDIRECTORY ${SUBDIRECTORIES})
    if (IS_DIRECTORY ${SUBDIRECTORY})
      if (EXISTS ${SUBDIRECTORY}/CMakeLists.txt)
        add_subdirectory(${SUBDIRECTORY})
      endif()
    endif()
  endforeach(SUBDIRECTORY)
endfunction(test_directory)

test_directory()
