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

# Ensure that WiX is in the path
find_path(WIX_PATH candle.exe)
if (NOT WIX_PATH)
  message(WARNING "Unable to find WiX in the PATH. The WiX installer will be disabled.")
endif()

# Configure the installer scripts
configure_file(installer.cmake.nsi ${CMAKE_BINARY_DIR}/installer.nsi @ONLY)
configure_file(installer.cmake.wxs installer.wxs @ONLY)

# Compiler Runtime DLLs
if (MSVC)
  # Visual Studio
  set(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP true)
  include(InstallRequiredSystemLibraries)
  install(FILES ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS} DESTINATION .)
else()
  # MinGW
  get_filename_component(MINGW_DLL_DIR ${CMAKE_CXX_COMPILER} PATH)
  install(FILES
    ${MINGW_DLL_DIR}/libgcc_s_dw2-1.dll
    ${MINGW_DLL_DIR}/libstdc++-6.dll
    ${MINGW_DLL_DIR}/libwinpthread-1.dll
    DESTINATION .
  )
endif()

# Qt Libraries
get_target_property(QtCore_LOCATION Qt5::Core LOCATION)
get_filename_component(QT_DLL_DIR ${QtCore_LOCATION} PATH)
install(FILES
  ${QT_DLL_DIR}/icudt51.dll
  ${QT_DLL_DIR}/icuin51.dll
  ${QT_DLL_DIR}/icuuc51.dll
  ${QT_DLL_DIR}/Qt5Core.dll
  ${QT_DLL_DIR}/Qt5Gui.dll
  ${QT_DLL_DIR}/Qt5Widgets.dll
  ${CMAKE_SOURCE_DIR}/win/qt.conf
  DESTINATION .
)
# Qt Platform Plugin
install(FILES
  ${QT_DLL_DIR}/../plugins/platforms/qwindows.dll
  DESTINATION plugins/platforms
)

# Custom target to build the WiX installer. Should be run after the install
# target.
if (WIX_PATH)
  add_custom_target(installer
    COMMAND ${WIX_PATH}/candle.exe ${CMAKE_CURRENT_BINARY_DIR}/installer.wxs
    COMMAND ${WIX_PATH}/light.exe -ext WixUIExtension -ext WixUtilExtension
            -b ${CMAKE_INSTALL_PREFIX} -b ${CMAKE_SOURCE_DIR}/win
            -out "${PROJECT_LONGNAME} ${PROJECT_VERSION}.msi"
            installer.wixobj
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    VERBATIM
  )
endif()
