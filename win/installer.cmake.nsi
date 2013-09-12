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

!include "MUI.nsh"

!define EXE_BUILD_NAME "@CMAKE_PROJECT_NAME@.exe"
!define EXE_INSTALL_NAME "@PROJECT_LONGNAME@.exe"
!define APP_LONGNAME "@PROJECT_LONGNAME@"
!define APP_VERSION "@PROJECT_VERSION@"

!define DIST_DIR "@CMAKE_INSTALL_PREFIX@"
!define SOURCE_DIR "@CMAKE_SOURCE_DIR@"

Name "${APP_LONGNAME}"
OutFile "${APP_LONGNAME} ${APP_VERSION} Setup.exe"
!define ORGANISATION_NAME "${APP_LONGNAME} Project"
InstallDir "$PROGRAMFILES\${APP_LONGNAME}"
!define APP_REGISTRY_KEY "Software\${APP_LONGNAME}"
!define UNINSTALL_REGISTRY_KEY "${APP_LONGNAME}"
InstallDirRegKey HKLM "${APP_REGISTRY_KEY}" ""
SetCompressor /SOLID lzma

# Request admin privileges
RequestExecutionLevel admin

# Variables
Var StartMenuFolder

# Interface Settings
!define MUI_ABORTWARNING
#!define MUI_ICON "${SOURCE_DIR}\win\installer-icon.ico"
#!define MUI_HEADERIMAGE_BITMAP "${SOURCE_DIR}\win\installer-header.bmp" # Size: 150x57
#!define MUI_WELCOMEFINISHPAGE_BITMAP "${SOURCE_DIR}\win\installer-welcome.bmp" # Size: 164x314
#!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${SOURCE_DIR}\win\installer-welcome.bmp"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${SOURCE_DIR}\LICENCE"
!insertmacro MUI_PAGE_DIRECTORY
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "${APP_LONGNAME}"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKLM"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${APP_REGISTRY_KEY}"
!define START_MENU_REGISTRY_VALUE "Start Menu Folder"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${START_MENU_REGISTRY_VALUE}"
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\${EXE_INSTALL_NAME}"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

# Languages
!insertmacro MUI_LANGUAGE "English"

#==
# Installation
#==
Section Install
  SetOutPath "$INSTDIR"

  File "${SOURCE_DIR}\LICENCE"

  # App files
  File "/oname=${EXE_INSTALL_NAME}" "${DIST_DIR}\${EXE_BUILD_NAME}"

  # MinGW Runtimes
  File "${DIST_DIR}\libgcc_s_dw2-1.dll"
  File "${DIST_DIR}\libstdc++-6.dll"
  File "${DIST_DIR}\libwinpthread-1.dll"

  # ICU Unicode Libraries used by Qt
  File "${DIST_DIR}\icudt51.dll"
  File "${DIST_DIR}\icuin51.dll"
  File "${DIST_DIR}\icuuc51.dll"

  # Qt Libraries
  File "${DIST_DIR}\qt.conf"
  File "${DIST_DIR}\Qt5Core.dll"
  File "${DIST_DIR}\Qt5Gui.dll"
  File "${DIST_DIR}\Qt5Widgets.dll"

  # Qt Plugins
  SetOutPath "$INSTDIR\plugins\platforms"
  File "${DIST_DIR}\plugins\platforms\qwindows.dll"

  # Uninstaller
  WriteRegStr HKLM "${APP_REGISTRY_KEY}" "" $INSTDIR
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  !define UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_REGISTRY_KEY}"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "DisplayName" "${APP_LONGNAME}"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "QuietUninstallString" "$INSTDIR\Uninstall.exe /S"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "DisplayIcon" "$INSTDIR\${EXE_INSTALL_NAME}"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "DisplayVersion" "${APP_VERSION}"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "Publisher" "${ORGANISATION_NAME}"

  # Menu folder
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\${APP_LONGNAME}.lnk" "$INSTDIR\${EXE_INSTALL_NAME}"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

#==
# Uninstallation
#==
Section Uninstall
  Delete "$INSTDIR\LICENCE"

  # App files
  Delete "$INSTDIR\${EXE_INSTALL_NAME}"

  # MinGW Runtimes
  Delete "$INSTDIR\libgcc_s_dw2-1.dll"
  Delete "$INSTDIR\libstdc++-6.dll"
  Delete "$INSTDIR\libwinpthread-1.dll"

  # ICU Unicode Libraries used by Qt
  Delete "$INSTDIR\icudt51.dll"
  Delete "$INSTDIR\icuin51.dll"
  Delete "$INSTDIR\icuuc51.dll"

  # Qt Libraries
  Delete "$INSTDIR\qt.conf"
  Delete "$INSTDIR\Qt5Core.dll"
  Delete "$INSTDIR\Qt5Gui.dll"
  Delete "$INSTDIR\Qt5Widgets.dll"

  # Qt Plugins
  Delete "$INSTDIR\plugins\platforms\qwindows.dll"
  RMDir "$INSTDIR\plugins\platforms"
  RMDir "$INSTDIR\plugins"

  # Menu folder
  !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
  Delete "$SMPROGRAMS\$StartMenuFolder\${APP_LONGNAME}.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
  RMDir "$SMPROGRAMS\$StartMenuFolder"

  # Uninstaller
  Delete "$INSTDIR\Uninstall.exe"
  RMDir "$INSTDIR"
  DeleteRegKey /ifempty HKLM "${APP_REGISTRY_KEY}"
  DeleteRegKey /ifempty HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_REGISTRY_KEY}"
SectionEnd

# vim: ft=nsis
